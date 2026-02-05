import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var favoriteMovies: [Movie] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Chargement des favoris...")
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Réessayer") {
                            loadFavorites()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding()
                } else if favoriteMovies.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Aucun favori")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Ajoutez des films à vos favoris pour les retrouver ici")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(favoriteMovies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieCardView(movie: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mes Favoris")
            .onAppear {
                loadFavorites()
            }
            .onChange(of: authViewModel.currentUser?.favoriteMovieIds) { oldValue, newValue in
                loadFavorites()
            }
        }
    }
    
    private func loadFavorites() {
        guard let user = authViewModel.currentUser else { return }
        
        let favoriteIds = user.favoriteMovieIds
        
        guard !favoriteIds.isEmpty else {
            favoriteMovies = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            var movies: [Movie] = []
            
            for movieId in favoriteIds {
                do {
                    let movie = try await MovieAPIService.shared.fetchMovieDetails(id: movieId)
                    movies.append(movie)
                } catch {
                    // Continue même si un film échoue
                    continue
                }
            }
            
            await MainActor.run {
                self.favoriteMovies = movies
                self.isLoading = false
                
                if movies.isEmpty && !favoriteIds.isEmpty {
                    self.errorMessage = "Impossible de charger les favoris"
                }
            }
        }
    }
}
