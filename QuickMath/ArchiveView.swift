import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTab = 0
    @State private var selectedCategory: String = "All"

    private let tabs = ["Saved", "Weekly Digest"]

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                VStack(spacing: 0) {
                    // Tab picker
                    Picker("View", selection: $selectedTab) {
                        ForEach(tabs.indices, id: \.self) { i in
                            Text(tabs[i]).tag(i)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)

                    if selectedTab == 0 {
                        savedTab
                    } else {
                        weeklyTab
                    }
                }
            }
            .navigationTitle("My Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: Saved Facts

    private var savedTab: some View {
        Group {
            if appModel.savedFacts.isEmpty {
                emptyState(
                    icon: "bookmark",
                    title: "No saved facts yet",
                    message: "Tap the bookmark on any fact to save it here for later."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredSaved) { fact in
                            FactRow(fact: fact, onToggleSave: { appModel.toggleSave(fact) })
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
    }

    private var filteredSaved: [DailyFact] {
        selectedCategory == "All"
            ? appModel.savedFacts
            : appModel.savedFacts.filter { $0.category == selectedCategory }
    }

    // MARK: Weekly Digest

    private var weeklyTab: some View {
        Group {
            if appModel.weeklyFacts.isEmpty {
                emptyState(
                    icon: "calendar",
                    title: "No facts this week yet",
                    message: "Open the app each day to build your weekly digest."
                )
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Week summary header
                        HStack(spacing: 12) {
                            MetricTile(value: "\(appModel.weeklyFacts.count)", label: "This week")
                            MetricTile(value: "\(appModel.weeklyFacts.filter { $0.isSaved }.count)", label: "Saved")
                            MetricTile(value: topCategory(), label: "Top topic")
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                        // Category breakdown
                        categoryBreakdownCard

                        // Fact list
                        LazyVStack(spacing: 12) {
                            ForEach(appModel.weeklyFacts) { fact in
                                FactRow(fact: fact, onToggleSave: { appModel.toggleSave(fact) })
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var categoryBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BY CATEGORY")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            ForEach(AppModel.allCategories.filter { $0 != "All" }, id: \.self) { cat in
                let count = appModel.weeklyFacts.filter { $0.category == cat }.count
                if count > 0 {
                    HStack {
                        Text(cat)
                            .font(.subheadline)
                        Spacer()
                        Text("\(count) fact\(count == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        // Simple bar
                        GeometryReader { geo in
                            let maxCount = max(1, AppModel.allCategories.filter { $0 != "All" }.map { c in appModel.weeklyFacts.filter { $0.category == c }.count }.max() ?? 1)
                            let width = geo.size.width * CGFloat(count) / CGFloat(maxCount)
                            Capsule()
                                .fill(Color.qmAccent)
                                .frame(width: width, height: 6)
                        }
                        .frame(width: 60, height: 6)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 16)
    }

    // MARK: Helpers

    private func topCategory() -> String {
        let cats = AppModel.allCategories.filter { $0 != "All" }
        return cats.max(by: { a, b in
            appModel.weeklyFacts.filter { $0.category == a }.count <
            appModel.weeklyFacts.filter { $0.category == b }.count
        }) ?? "—"
    }

    private func emptyState(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(Color.qmAccent.opacity(0.5))
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Fact Row

private struct FactRow: View {
    let fact: DailyFact
    let onToggleSave: () -> Void

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(fact.category.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.qmAccent)
                    Text(fact.body)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(expanded ? nil : 3)
                        .lineSpacing(3)
                    Text(dateLabel(fact.dateShown))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: onToggleSave) {
                    Image(systemName: fact.isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(fact.isSaved ? Color.qmAccent : .secondary)
                        .frame(width: 36, height: 36)
                }
            }

            if expanded {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 5) {
                        Image(systemName: "info.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Color.qmAccent)
                        Text("Why it's true")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.qmAccent)
                    }
                    Text(fact.sourceNote)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)
                }
                .padding(10)
                .background(Color.qmAccent.opacity(0.07), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.top, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(14)
        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture {
            Haptics.tap()
            withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
        }
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }

    private func dateLabel(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
