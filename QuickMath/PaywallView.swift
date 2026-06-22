import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let benefits = [
        ("bookmark.fill", "Saved facts collection you can browse anytime"),
        ("slider.horizontal.3", "Category filters to weight your daily fact"),
        ("bell.badge.fill", "Weekly digest notification summarizing the week's facts"),
    ]

    var body: some View {
        ZStack {
            QMBackground()
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 20)

                    // Icon + title
                    VStack(spacing: 14) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundStyle(Color.qmAccent)

                        Text("Did You Know Pro")
                            .font(.largeTitle.weight(.bold))
                            .multilineTextAlignment(.center)

                        Text("$0.99 / month. Auto-renews until you cancel.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)

                    // Benefits
                    VStack(spacing: 14) {
                        ForEach(benefits, id: \.0) { icon, text in
                            HStack(spacing: 14) {
                                Image(systemName: icon)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color.qmAccent)
                                    .frame(width: 32)
                                Text(text)
                                    .font(.body)
                                    .lineLimit(2)
                                Spacer()
                            }
                            .padding(14)
                            .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 20)

                    // CTA
                    VStack(spacing: 12) {
                        Button {
                            Task {
                                Haptics.tap()
                                _ = await store.purchase()
                            }
                        } label: {
                            Group {
                                if store.purchaseInFlight {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Unlock for \(store.displayPrice)/month")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .prominentButton()
                        .disabled(store.purchaseInFlight)
                        .padding(.horizontal, 20)

                        Button("Restore Purchase") {
                            Task {
                                Haptics.tap()
                                await store.restore()
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }

                    // Legal / disclosure
                    VStack(spacing: 10) {
                        Text("Subscription auto-renews monthly at \(store.displayPrice) until canceled. Cancel anytime in your Apple account settings. Payment charged to your Apple ID account at confirmation of purchase.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        HStack(spacing: 16) {
                            Button("Terms of Use") {
                                openURL(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                            }
                            Text("·")
                                .foregroundStyle(.secondary)
                            Button("Privacy Policy") {
                                openURL(URL(string: "https://shimondeitel.github.io/factoid-site/privacy.html")!)
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .onChange(of: store.isPro) { _, newValue in
            if newValue { dismiss() }
        }
    }
}
