import StoreKit
import Observation

@Observable
final class PurchaseManager {

    static let shared = PurchaseManager()

    var isPro = false
    var isLoading = false
    var product: Product?

    private let productId = "com.zzoutuo.TrailPin.pro"
    private var updateTask: Task<Void, Never>?

    init() {
        updateTask = Task {
            await loadProduct()
            await checkPurchased()
            await listenForTransactions()
        }
    }

    deinit {
        updateTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productId])
            product = products.first
        } catch {
        }
    }

    func purchase() async {
        guard let product = product else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    isPro = true
                    await transaction.finish()
                case .unverified:
                    break
                }
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
        }
    }

    func restorePurchases() {
        Task {
            try? await AppStore.sync()
            await checkPurchased()
        }
    }

    private func checkPurchased() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productId {
                    isPro = transaction.revocationDate == nil
                    return
                }
            }
        }
        isPro = false
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                if transaction.productID == productId {
                    isPro = transaction.revocationDate == nil
                }
                await transaction.finish()
            }
        }
    }
}
