import SwiftUI

struct MainTabView: View {
    @StateObject private var movieViewModel = MovieViewModel()
    
    var body: some View {
        TabView {
            MovieListView()
                .environmentObject(movieViewModel)
                .tabItem {
                    Label("Films", systemImage: "film")
                        .accessibilityIdentifier("tab_movies") // Place-le ici ou sur le Label
                }
                .tag(0) // Optionnel mais recommandé
            
            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "heart.fill")
                        .accessibilityIdentifier("tab_favorites")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                        .accessibilityIdentifier("tab_profile")
                }
                .tag(2)
        }
        .accessibilityIdentifier("main_tab_bar") // Ajoute ceci pour aider le test à trouver la barre
        .accentColor(.red)
    }
}
