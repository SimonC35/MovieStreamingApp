import SwiftUI

struct MainTabView: View {
    @StateObject private var movieViewModel = MovieViewModel()

    var body: some View {
        TabView {
            MovieListView()
                .environmentObject(movieViewModel)
                .tabItem {
                    Label("Films", systemImage: "film")
                }
                .accessibilityIdentifier("tab_movies")

            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "heart.fill")
                }
                .accessibilityIdentifier("tab_favorites")

            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .accessibilityIdentifier("tab_profile")
        }
        .accentColor(.red)
    }
}
