import Foundation
import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    
    private let apiService = MovieAPIService.shared
    
    func fetchPopularMovies() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedMovies = try await apiService.fetchPopularMovies()
                await MainActor.run {
                    self.movies = fetchedMovies
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Erreur lors du chargement des films"
                    self.isLoading = false
                }
            }
        }
    }
}
