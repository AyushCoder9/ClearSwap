import SwiftUI
import SwiftData

@main
struct ClearSwapApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Deal.self, ItemValuation.self, ReceiptRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if onboardingCompleted {
                RootTabView()
                    .environmentObject(coordinator)
                    .preferredColorScheme(.dark)
                    .task {
                        SeedDataService.seedIfNeeded(context: sharedModelContainer.mainContext)
                    }
            } else {
                OnboardingView()
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
