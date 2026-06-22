import SwiftUI

struct HomeView: View {
    var forceScreen: String? = nil

    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store

    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showInsights = false
    @State private var showFact = false

    var body: some View {
        ZStack {
            QMBackground()
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Did You Know")
                                .font(.largeTitle.weight(.bold))
                            Text(today())
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            Haptics.tap()
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Today's fact card
                    GridView()
                        .padding(.horizontal, 16)

                    // Stats row
                    HStack(spacing: 12) {
                        MetricTile(value: "\(appModel.allShownFacts.count)", label: "Facts seen")
                        MetricTile(value: "\(appModel.savedFacts.count)", label: "Saved")
                        MetricTile(value: "\(appModel.weeklyFacts.count)", label: "This week")
                    }
                    .padding(.horizontal, 16)

                    // Pro tile
                    Button {
                        Haptics.tap()
                        if store.isPro {
                            showInsights = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: store.isPro ? "archivebox.fill" : "lock.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(store.isPro ? Color.qmAccent : .secondary)
                                .frame(width: 36)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(store.isPro ? "My Collection" : "Did You Know Pro")
                                    .font(.headline)
                                Text(store.isPro ? "Browse your saved facts & weekly digest" : "Save facts, filter by topic & more")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(16)
                        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 40)
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(store)
                .environmentObject(appModel)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .environmentObject(store)
        }
        .sheet(isPresented: $showInsights) {
            InsightsView()
                .environmentObject(appModel)
                .environmentObject(store)
        }
        .onAppear {
            if forceScreen == "paywall" { showPaywall = true }
            if forceScreen == "insights" { showInsights = true }
            if forceScreen == "settings" { showSettings = true }
        }
    }

    private func today() -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: .now)
    }
}
