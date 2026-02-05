import SwiftUI

struct MovieListView: View {
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if movieViewModel.isLoading {
                    ProgressView("Chargement des films...")
                        .padding()
                } else if let error = movieViewModel.errorMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.secondary)
                        Button("Réessayer") {
                            movieViewModel.fetchPopularMovies()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding()
                } else if movieViewModel.movies.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "film.stack")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Aucun film trouvé")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(movieViewModel.movies) { movie in
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
            .navigationTitle("Films")
            .searchable(text: $movieViewModel.searchQuery, prompt: "Rechercher un film")
            .onSubmit(of: .search) {
                movieViewModel.searchMovies()
            }
            .onChange(of: movieViewModel.searchQuery) { oldValue, newValue in
                if newValue.isEmpty {
                    movieViewModel.fetchPopularMovies()
                }
            }
            .onAppear {
                if movieViewModel.movies.isEmpty {
                    movieViewModel.fetchPopularMovies()
                }
            }
        }
    }
}

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image du film
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 240)
            .clipped()
            .cornerRadius(10)
            
            // Titre
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Note
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                Text(movie.ratingText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
