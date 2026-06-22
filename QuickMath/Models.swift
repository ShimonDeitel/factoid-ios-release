import SwiftUI
import SwiftData

// MARK: - SwiftData Models

@Model
final class DailyFact {
    var id: String
    var body: String
    var category: String
    var sourceNote: String
    var dateShown: Date
    var isSaved: Bool
    var reactionEmoji: String

    init(id: String, body: String, category: String, sourceNote: String, dateShown: Date = .now, isSaved: Bool = false, reactionEmoji: String = "") {
        self.id = id
        self.body = body
        self.category = category
        self.sourceNote = sourceNote
        self.dateShown = dateShown
        self.isSaved = isSaved
        self.reactionEmoji = reactionEmoji
    }
}

@Model
final class ReadLog {
    var factID: String
    var openedAt: Date

    init(factID: String, openedAt: Date = .now) {
        self.factID = factID
        self.openedAt = openedAt
    }
}

// MARK: - Built-in Fact Catalog

struct FactEntry {
    let id: String
    let body: String
    let category: String
    let sourceNote: String
}

let builtInFacts: [FactEntry] = [
    FactEntry(id: "f001", body: "Honey never spoils — archaeologists found 3,000-year-old honey in Egyptian tombs that was still edible.", category: "Science", sourceNote: "Low moisture + hydrogen peroxide make honey self-preserving."),
    FactEntry(id: "f002", body: "A day on Venus is longer than a year on Venus.", category: "Science", sourceNote: "Venus rotates so slowly (243 Earth days) that it orbits the Sun (225 days) faster."),
    FactEntry(id: "f003", body: "Cleopatra lived closer in time to the Moon landing than to the construction of the Great Pyramid.", category: "History", sourceNote: "Great Pyramid: ~2560 BC. Cleopatra: ~69 BC. Moon landing: 1969 AD."),
    FactEntry(id: "f004", body: "Octopuses have three hearts, blue blood, and can edit their own RNA.", category: "Nature", sourceNote: "Blue blood uses copper-based hemocyanin instead of iron-based hemoglobin."),
    FactEntry(id: "f005", body: "The shortest war in history lasted just 38–45 minutes — the Anglo-Zanzibar War of 1896.", category: "History", sourceNote: "Zanzibar surrendered after the British Royal Navy opened fire."),
    FactEntry(id: "f006", body: "There are more possible iterations of a game of chess than there are atoms in the observable universe.", category: "Science", sourceNote: "Shannon number: ~10^120 chess games vs ~10^80 atoms."),
    FactEntry(id: "f007", body: "Bananas are technically berries, but strawberries are not.", category: "Nature", sourceNote: "Botanically, a berry forms from a single flower's ovary. Strawberries form from multiple ovaries."),
    FactEntry(id: "f008", body: "Oxford University is older than the Aztec Empire.", category: "History", sourceNote: "Teaching at Oxford started around 1096 AD; the Aztec Empire began ~1428 AD."),
    FactEntry(id: "f009", body: "A group of flamingos is called a 'flamboyance'.", category: "Nature", sourceNote: "Collective noun coined because of their vivid pink plumage and dramatic postures."),
    FactEntry(id: "f010", body: "Hot water can freeze faster than cold water under certain conditions — the Mpemba effect.", category: "Science", sourceNote: "First noted by student Erasto Mpemba in 1963; the exact mechanism is still debated."),
    FactEntry(id: "f011", body: "The human body contains enough carbon to make about 9,000 pencils.", category: "Science", sourceNote: "About 18% of body mass is carbon — roughly 16 kg for a 90 kg person."),
    FactEntry(id: "f012", body: "Nintendo was founded in 1889 — as a playing card company.", category: "History", sourceNote: "Fusajiro Yamauchi started making handmade hanafuda cards in Kyoto."),
    FactEntry(id: "f013", body: "A bolt of lightning is five times hotter than the surface of the Sun.", category: "Science", sourceNote: "Lightning channel: ~30,000 K. Sun surface: ~5,778 K."),
    FactEntry(id: "f014", body: "Wombat feces are cube-shaped — the only known animal to produce square droppings.", category: "Nature", sourceNote: "Cubic scat helps mark territory on flat surfaces without rolling away."),
    FactEntry(id: "f015", body: "The inventor of the Frisbee was turned into a Frisbee after he died.", category: "History", sourceNote: "Walter Morrison's ashes were molded into a memorial disc by his family."),
    FactEntry(id: "f016", body: "Sharks are older than trees — they predate land forests by about 50 million years.", category: "Nature", sourceNote: "Sharks: ~450 million years old. Trees evolved ~385 million years ago."),
    FactEntry(id: "f017", body: "The Eiffel Tower can be 15 cm taller in summer due to thermal expansion of the iron.", category: "Science", sourceNote: "Heat causes the metal lattice to expand measurably over its 300 m height."),
    FactEntry(id: "f018", body: "Cleopatra spoke nine languages; Julius Caesar and Mark Antony reportedly spoke only Latin and Greek.", category: "History", sourceNote: "She was the first Ptolemaic ruler to learn Egyptian."),
    FactEntry(id: "f019", body: "An octopus can open a child-proof pill bottle that takes many adults several attempts.", category: "Nature", sourceNote: "Demonstrates their problem-solving intelligence and dexterous arms."),
    FactEntry(id: "f020", body: "There is a species of jellyfish (Turritopsis dohrnii) that is biologically immortal.", category: "Nature", sourceNote: "It can revert to its juvenile polyp state after reaching adulthood — essentially resetting its age."),
    FactEntry(id: "f021", body: "The Great Wall of China is not visible from space with the naked eye.", category: "History", sourceNote: "Astronauts have confirmed it's too narrow (~9 m wide) to spot from orbit."),
    FactEntry(id: "f022", body: "Crows can remember human faces and hold grudges for years.", category: "Nature", sourceNote: "Studies show crows recognize and react negatively to people who previously threatened them."),
    FactEntry(id: "f023", body: "The world's quietest room, at Microsoft HQ, measures -20.6 dBA — so quiet you can hear your own blood flow.", category: "Science", sourceNote: "Most people feel disoriented after just a few minutes inside."),
    FactEntry(id: "f024", body: "Goldfish have a memory span of at least three months, not three seconds.", category: "Nature", sourceNote: "Researchers trained goldfish to press levers at specific times — proving multi-month memory."),
    FactEntry(id: "f025", body: "The Pyramids of Giza were already ancient ruins to the ancient Romans.", category: "History", sourceNote: "The pyramids were built ~2560 BC; Romans visited them as tourists around 30 BC."),
    FactEntry(id: "f026", body: "A teaspoon of neutron star material would weigh about 1 billion tons.", category: "Science", sourceNote: "Neutron stars pack 1.4 solar masses into a sphere ~20 km across."),
    FactEntry(id: "f027", body: "Elephants are the only animals that can't jump.", category: "Nature", sourceNote: "Their weight and bone structure make it physically impossible to get all four feet off the ground."),
    FactEntry(id: "f028", body: "The first alarm clock could only ring at 4 AM.", category: "History", sourceNote: "Levi Hutchins invented it in 1787 for his own use and never patented it."),
    FactEntry(id: "f029", body: "Humans share 50% of their DNA with bananas.", category: "Science", sourceNote: "All life shares basic cellular machinery — the overlap is in fundamental metabolic genes."),
    FactEntry(id: "f030", body: "The Titanic's swimming pool is still filled with water at the bottom of the Atlantic Ocean.", category: "History", sourceNote: "Deep-sea footage confirms water remains inside the sealed pool chamber."),
    FactEntry(id: "f031", body: "Caterpillars completely liquefy inside their chrysalis before reforming as butterflies.", category: "Nature", sourceNote: "Nearly all larval tissue breaks down into a cellular soup; only a few clusters persist."),
    FactEntry(id: "f032", body: "The dot above the lowercase 'i' and 'j' is called a 'tittle'.", category: "History", sourceNote: "From Medieval Latin 'titulus', meaning a small mark."),
    FactEntry(id: "f033", body: "There are more stars in the universe than grains of sand on all of Earth's beaches.", category: "Science", sourceNote: "Estimated ~10^24 stars vs ~10^19 grains of sand on Earth's beaches."),
    FactEntry(id: "f034", body: "Sea otters hold hands while sleeping so they don't drift apart.", category: "Nature", sourceNote: "This behavior is called 'rafting' and is mostly seen in females with pups."),
    FactEntry(id: "f035", body: "The first webcam was invented to monitor a coffee pot at Cambridge University in 1991.", category: "History", sourceNote: "Researchers set it up so they could check if the pot was empty before making the trip."),
    FactEntry(id: "f036", body: "Your stomach acid is strong enough to dissolve a razor blade.", category: "Science", sourceNote: "Gastric acid (HCl) has a pH of 1.5–3.5 and can dissolve many metals given enough time."),
    FactEntry(id: "f037", body: "Sloths can hold their breath longer than dolphins — up to 40 minutes.", category: "Nature", sourceNote: "They slow metabolism so dramatically that oxygen demands drop to near zero."),
    FactEntry(id: "f038", body: "The word 'salary' comes from the Latin 'salarium' — meaning salt payment.", category: "History", sourceNote: "Roman soldiers were sometimes paid in salt or given money to buy it."),
    FactEntry(id: "f039", body: "Water can boil and freeze at the same time — at the 'triple point' of 0.01 °C and 611.73 Pa.", category: "Science", sourceNote: "At this exact temperature and pressure, all three phases of water coexist simultaneously."),
    FactEntry(id: "f040", body: "A day on Mars is 24 hours, 39 minutes, and 35 seconds — almost the same as on Earth.", category: "Science", sourceNote: "This is called a 'sol' and is why Mars missions use near-Earth scheduling."),
    FactEntry(id: "f041", body: "Pineapples take about two years to grow to full size.", category: "Nature", sourceNote: "Each plant produces only one pineapple per growth cycle, which lasts 18–24 months."),
    FactEntry(id: "f042", body: "The Apollo 11 computer had less processing power than a modern USB stick.", category: "History", sourceNote: "The Apollo Guidance Computer ran at 2 MHz with 4 KB of RAM. A basic USB controller has more."),
    FactEntry(id: "f043", body: "Polar bears have black skin under their white fur to absorb heat from the sun.", category: "Nature", sourceNote: "The fur also appears white to reflect surroundings, but each hair shaft is actually transparent."),
    FactEntry(id: "f044", body: "The average person walks about 100,000 miles in a lifetime — equivalent to circling the Earth four times.", category: "Science", sourceNote: "Based on ~8,000 steps/day over 80 years."),
    FactEntry(id: "f045", body: "Playing cards were used as currency in 18th-century Canada when coins ran out.", category: "History", sourceNote: "The Governor of New France authorized playing cards as legal tender in 1685."),
    FactEntry(id: "f046", body: "A group of porcupines is called a 'prickle'.", category: "Nature", sourceNote: "Collective nouns for animals are often delightfully descriptive."),
    FactEntry(id: "f047", body: "The Eiffel Tower was originally planned to be demolished after 20 years.", category: "History", sourceNote: "Built for the 1889 World's Fair, it was saved because it served as a useful radio transmission tower."),
    FactEntry(id: "f048", body: "Sound travels about 4.3 times faster through water than through air.", category: "Science", sourceNote: "In air: ~343 m/s. In water: ~1,480 m/s, due to greater density and elasticity."),
    FactEntry(id: "f049", body: "Koalas have unique fingerprints nearly identical to humans — even fooling forensic experts.", category: "Nature", sourceNote: "Koalas independently evolved friction ridges for grip when climbing eucalyptus trees."),
    FactEntry(id: "f050", body: "The word 'clue' originally meant a ball of yarn — from the myth of Theseus using thread in the labyrinth.", category: "History", sourceNote: "From Old English 'cliewen' (ball of yarn), adapted to mean 'something that guides you.'"),
    FactEntry(id: "f051", body: "You could fit all the planets of the Solar System between the Earth and the Moon.", category: "Science", sourceNote: "Earth-Moon distance: ~384,400 km. Sum of planetary diameters: ~372,000 km."),
    FactEntry(id: "f052", body: "A group of owls is called a 'parliament'.", category: "Nature", sourceNote: "This term dates to C.S. Lewis's 'The Chronicles of Narnia,' where owls held parliamentary meetings."),
    FactEntry(id: "f053", body: "The first product to have a barcode scanned was a pack of Wrigley's chewing gum in 1974.", category: "History", sourceNote: "It happened at a Marsh supermarket in Troy, Ohio, on June 26, 1974."),
    FactEntry(id: "f054", body: "Your brain is more active at night than during the day.", category: "Science", sourceNote: "During REM sleep, neural activity rivals or exceeds waking levels, supporting memory consolidation."),
    FactEntry(id: "f055", body: "A cubic mile of fog is made up of less than a gallon of water.", category: "Science", sourceNote: "Fog consists of such tiny droplets that even a vast cloud contains surprisingly little actual water."),
    FactEntry(id: "f056", body: "The longest English word that can be typed using only the top row of a keyboard is 'typewriter'.", category: "History", sourceNote: "QWERTY top row: Q W E R T Y U I O P — 'typewriter' uses only these letters."),
    FactEntry(id: "f057", body: "Trees communicate and share nutrients with each other through underground fungal networks.", category: "Nature", sourceNote: "Called the 'Wood Wide Web', fungi link roots enabling nutrient transfers between trees."),
    FactEntry(id: "f058", body: "The human eye can detect a single photon of light in complete darkness.", category: "Science", sourceNote: "Studies show retinal cells can respond to individual photons under ideal conditions."),
    FactEntry(id: "f059", body: "Ants stretch and yawn when they wake up, just like humans.", category: "Nature", sourceNote: "Observed on video in fire ant colonies; the behavior is thought to prime their motor systems."),
    FactEntry(id: "f060", body: "The 'sixth sick sheik's sixth sheep's sick' is considered the world's hardest tongue twister by Guinness.", category: "History", sourceNote: "Entered the Guinness Book of Records in 1974 as the most difficult English tongue twister."),
]

// MARK: - AppModel

@MainActor
final class AppModel: ObservableObject {
    let container: ModelContainer
    weak var store: Store?

    @Published private(set) var todayFact: DailyFact?
    @Published private(set) var savedFacts: [DailyFact] = []
    @Published private(set) var allShownFacts: [DailyFact] = []
    @Published private(set) var weeklyFacts: [DailyFact] = []

    // Category filter preference (Pro)
    @Published var preferredCategory: String = "All"
    static let allCategories = ["All", "Science", "History", "Nature"]

    init(container: ModelContainer) {
        self.container = container
        reload()
    }

    static func makeContainer() -> ModelContainer {
        let schema = Schema([DailyFact.self, ReadLog.self])
        do {
            return try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema)])
        } catch {
            // Fallback to in-memory store so app never crashes on init
            return (try? ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])) ?? {
                fatalError("Cannot create ModelContainer: \(error)")
            }()
        }
    }

    func reload() {
        let context = container.mainContext
        let allFacts = (try? context.fetch(FetchDescriptor<DailyFact>(sortBy: [SortDescriptor(\.dateShown, order: .reverse)]))) ?? []
        allShownFacts = allFacts
        savedFacts = allFacts.filter { $0.isSaved }

        // Weekly digest: last 7 days
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .distantPast
        weeklyFacts = allFacts.filter { $0.dateShown >= sevenDaysAgo }

        // Determine today's fact
        let todayStart = Calendar.current.startOfDay(for: .now)
        let todayEnd = Calendar.current.date(byAdding: .day, value: 1, to: todayStart) ?? .distantFuture
        if let existing = allFacts.first(where: { $0.dateShown >= todayStart && $0.dateShown < todayEnd }) {
            todayFact = existing
        } else {
            // Pick a new fact for today (category-weighted if Pro + preference set)
            let shownIDs = Set(allFacts.map { $0.id })
            let pool = preferredCategory == "All"
                ? builtInFacts.filter { !shownIDs.contains($0.id) }
                : builtInFacts.filter { !shownIDs.contains($0.id) && $0.category == preferredCategory }
            let candidates = pool.isEmpty ? builtInFacts : pool
            // Deterministic selection by day-of-year so the same device always shows same fact today
            let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
            let entry = candidates[(dayIndex - 1) % candidates.count]
            let fact = DailyFact(
                id: entry.id,
                body: entry.body,
                category: entry.category,
                sourceNote: entry.sourceNote,
                dateShown: .now
            )
            context.insert(fact)
            try? context.save()
            todayFact = fact
        }
        // Log read
        logRead(factID: todayFact?.id ?? "")
    }

    func refresh() { reload() }

    func toggleSave(_ fact: DailyFact) {
        fact.isSaved.toggle()
        try? container.mainContext.save()
        reload()
        Haptics.tap()
    }

    func setReaction(_ fact: DailyFact, emoji: String) {
        fact.reactionEmoji = emoji
        try? container.mainContext.save()
        reload()
    }

    func deleteAllData() {
        let context = container.mainContext
        try? context.delete(model: DailyFact.self)
        try? context.delete(model: ReadLog.self)
        try? context.save()
        todayFact = nil
        savedFacts = []
        allShownFacts = []
        weeklyFacts = []
        reload()
    }

    private func logRead(factID: String) {
        guard !factID.isEmpty else { return }
        let log = ReadLog(factID: factID, openedAt: .now)
        container.mainContext.insert(log)
        try? container.mainContext.save()
    }
}
