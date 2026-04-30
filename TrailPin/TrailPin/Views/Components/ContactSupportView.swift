import SwiftUI

struct ContactSupportView: View {
    @State private var feedbackText = ""
    @State private var showSuccessAlert = false

    var body: some View {
        Form {
            Section("Send Feedback") {
                TextEditor(text: $feedbackText)
                    .frame(minHeight: 120)
            }

            Section {
                Button {
                    sendFeedback()
                } label: {
                    HStack {
                        Spacer()
                        Text("Send Feedback")
                            .bold()
                        Spacer()
                    }
                }
                .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            Section("Other Ways to Reach Us") {
                Link(destination: URL(string: "mailto:support@trailpin.app")!) {
                    Label("Email: support@trailpin.app", systemImage: "envelope")
                }

                Link(destination: URL(string: "https://asunnyboy861.github.io/TrailPin/support.html")!) {
                    Label("Support Page", systemImage: "globe")
                }
            }
        }
        .navigationTitle("Contact Support")
        .alert("Thank You!", isPresented: $showSuccessAlert) {
            Button("OK") {
                feedbackText = ""
            }
        } message: {
            Text("Your feedback has been received. We'll get back to you soon.")
        }
    }

    private func sendFeedback() {
        let subject = "TrailPin Feedback"
        let body = feedbackText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "mailto:support@trailpin.app?subject=\(subject)&body=\(body)") {
            UIApplication.shared.open(url)
        }
        showSuccessAlert = true
    }
}
