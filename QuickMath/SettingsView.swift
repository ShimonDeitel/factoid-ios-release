import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @AppStorage("quickmath.theme") private var themeRaw = AppTheme.system.rawValue
    @State private var showPaywall = false
    @State private var showDeleteConfirm = false

    private var theme: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: themeRaw) ?? .system },
            set: { themeRaw = $0.rawValue }
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                List {
                    // Pro section
                    Section("Subscription") {
                        if store.isPro {
                            HStack {
                                Label("Did You Know Pro", systemImage: "checkmark.seal.fill")
                                    .foregroundStyle(Color.qmAccent)
                                Spacer()
                                Text("Active")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Button {
                                openURL(URL(string: "https://apps.apple.com/account/subscriptions")!)
                            } label: {
                                Label("Manage Subscription", systemImage: "arrow.up.right.square")
                            }
                        } else {
                            Button {
                                Haptics.tap()
                                showPaywall = true
                            } label: {
                                Label("Upgrade to Pro — \(store.displayPrice)/mo", systemImage: "lightbulb.fill")
                                    .foregroundStyle(Color.qmAccent)
                            }
                            Button {
                                Task {
                                    Haptics.tap()
                                    await store.restore()
                                }
                            } label: {
                                Label("Restore Purchase", systemImage: "arrow.clockwise")
                            }
                        }
                    }

                    // Appearance
                    Section("Appearance") {
                        Picker("Theme", selection: theme) {
                            ForEach(AppTheme.allCases) { t in
                                Text(t.label).tag(t)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    // Legal
                    Section("Legal") {
                        Button {
                            openURL(URL(string: "https://shimondeitel.github.io/factoid-site/privacy.html")!)
                        } label: {
                            Label("Privacy Policy", systemImage: "hand.raised")
                        }
                        Button {
                            openURL(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                        } label: {
                            Label("Terms of Use", systemImage: "doc.text")
                        }
                    }

                    // Data
                    Section("Data") {
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            Label("Delete all data", systemImage: "trash")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(store)
            }
            .confirmationDialog("Delete all data?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    appModel.deleteAllData()
                    Haptics.warning()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently remove your fact history and saved collection. This cannot be undone.")
            }
        }
    }
}
