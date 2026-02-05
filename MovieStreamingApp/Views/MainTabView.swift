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
            
            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .accentColor(.red)
    }
}
