import StoreKit
import Observation

@Observable
final class PurchaseManager {

    static let shared = PurchaseManager()

    var isPro = false
    var isLoading = false
    var product: Product?
    var errorMessage: String?
    var showError = false
    var purchaseSuccess = false

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
            if product == nil {
                errorMessage = "Product not found. Please try again later."
                showError = true
            }
        } catch {
            errorMessage = "Failed to load product: \(error.localizedDescription)"
            showError = true
        }
    }

    @MainActor
    func purchase() async {
        guard let product = product else {
            errorMessage = "Product not available. Please check your internet connection."
            showError = true
            await loadProduct()
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    isPro = true
                    purchaseSuccess = true
                    await transaction.finish()
                case .unverified(let transaction, let error):
                    errorMessage = "Purchase verification failed: \(error.localizedDescription)"
                    showError = true
                    await transaction.finish()
                }
            case .pending:
                errorMessage = "Purchase is pending approval."
                showError = true
            case .userCancelled:
                break
            @unknown default:
                errorMessage = "Unknown purchase result."
                showError = true
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            showError = true
        }
    }

    func restorePurchases() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                try await AppStore.sync()
                await checkPurchased()
                if isPro {
                    purchaseSuccess = true
                } else {
                    errorMessage = "No previous purchases found."
                    showError = true
                }
            } catch {
                errorMessage = "Restore failed: \(error.localizedDescription)"
                showError = true
            }
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
