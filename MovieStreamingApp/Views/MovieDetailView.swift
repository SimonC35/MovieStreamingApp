import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    let movie: Movie
    
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(2/3, contentMode: .fit)
                            .overlay {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 50))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    // Titre
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Note et date
                    HStack(spacing: 20) {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(movie.ratingText)
                                .fontWeight(.semibold)
                            Text("/ 10")
                                .foregroundColor(.secondary)
                        }
                        
                        if let releaseDate = movie.releaseDate {
                            HStack(spacing: 5) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.secondary)
                                Text(releaseDate)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Bouton favoris
                    Button(action: {
                        toggleFavorite()
                    }) {
                        HStack {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                            Text(isFavorite ? "Retirer des favoris" : "Ajouter aux favoris")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFavorite ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Synopsis
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synopsis")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(movie.description.isEmpty ? "Aucune description disponible." : movie.description)
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isFavorite = authViewModel.isFavorite(movieId: movie.id)
        }
    }
    
    private func toggleFavorite() {
        if isFavorite {
            authViewModel.removeFavorite(movieId: movie.id)
        } else {
            authViewModel.addFavorite(movieId: movie.id)
        }
        isFavorite.toggle()
    }
}
