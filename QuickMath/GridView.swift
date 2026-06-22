import SwiftUI

struct GridView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store

    @State private var revealed = false
    @State private var showReactions = false

    private let reactions = ["🤯", "😮", "🤓", "😂", "💡"]

    var body: some View {
        VStack(spacing: 0) {
            if let fact = appModel.todayFact {
                // Category badge
                HStack {
                    Text(fact.category.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.qmAccent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.qmAccent.opacity(0.1), in: Capsule())
                    Spacer()
                    Text("TODAY")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)

                // Fact body
                Text(fact.body)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                // Why-it's-true note (reveal)
                if revealed {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle.fill")
                                .font(.caption)
                                .foregroundStyle(Color.qmAccent)
                            Text("Why it's true")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.qmAccent)
                        }
                        Text(fact.sourceNote)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color.qmAccent.opacity(0.07), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // Action row
                HStack(spacing: 12) {
                    // Reveal button
                    Button {
                        Haptics.tap()
                        withAnimation(.easeInOut(duration: 0.25)) {
                            revealed.toggle()
                        }
                    } label: {
                        Label(revealed ? "Hide" : "Why?", systemImage: revealed ? "eye.slash" : "lightbulb")
                            .font(.subheadline.weight(.medium))
                    }
                    .softButton()

                    Spacer()

                    // Reactions toggle (Pro)
                    if store.isPro {
                        Button {
                            Haptics.tap()
                            withAnimation { showReactions.toggle() }
                        } label: {
                            Text(fact.reactionEmoji.isEmpty ? "React" : fact.reactionEmoji)
                                .font(.subheadline.weight(.medium))
                        }
                        .softButton()
                    }

                    // Save button (Pro)
                    Button {
                        if store.isPro {
                            appModel.toggleSave(fact)
                            if fact.isSaved { Haptics.success() }
                        } else {
                            Haptics.warning()
                        }
                    } label: {
                        Image(systemName: fact.isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(fact.isSaved ? Color.qmAccent : .secondary)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                // Reaction picker (Pro)
                if showReactions && store.isPro {
                    HStack(spacing: 16) {
                        ForEach(reactions, id: \.self) { emoji in
                            Button {
                                appModel.setReaction(fact, emoji: emoji)
                                Haptics.tap()
                                withAnimation { showReactions = false }
                            } label: {
                                Text(emoji)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(fact.reactionEmoji == emoji ? Color.qmAccent.opacity(0.15) : Color.clear, in: Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }

            } else {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "lightbulb")
                        .font(.system(size: 48, weight: .light))
                        .foregroundStyle(Color.qmAccent.opacity(0.6))
                    Text("Loading today's fact...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
            }
        }
        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .animation(.easeInOut(duration: 0.2), value: revealed)
        .animation(.easeInOut(duration: 0.2), value: showReactions)
        .onAppear { revealed = false; showReactions = false }
        .onChange(of: appModel.todayFact?.id) { _, _ in
            revealed = false
            showReactions = false
        }
    }
}
