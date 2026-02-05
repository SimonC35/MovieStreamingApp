import SwiftUI

@main
struct MovieStreamingApp: App {

    @StateObject private var authViewModel = AuthViewModel()

    init() {
        // Mode spécial pour les UI Tests
        if ProcessInfo.processInfo.arguments.contains("UI_TEST") {
            // Reset total de la session utilisateur
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
                UserDefaults.standard.synchronize()
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
