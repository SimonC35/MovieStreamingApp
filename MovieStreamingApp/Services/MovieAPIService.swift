import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unauthorized
}

class MovieAPIService {
    static let shared = MovieAPIService()
    
    private let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3M2MzOGQ1NDAyOTgxNWMxOTQxN2Y4MWJmMDQ0YzU2ZiIsIm5iZiI6MTc3MDI4NzE3MC4wMiwic3ViIjoiNjk4NDcwNDI3NzQ1ZjZiMzc5OTk5M2RkIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.KIqH26ujzogZd5A5WjcH3J-e3l6LBLVZkkimB6QbLQI"
    private let baseURL = "https://api.themoviedb.org/3"
    
    private init() {}
    
    // Fonction helper pour créer une requête avec le header Authorization
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        return request
    }
    
    /// Récupère les films populaires
    func fetchPopularMovies(page: Int = 1) async throws -> [Movie] {
        let urlString = "\(baseURL)/movie/popular?language=en-US&page=1"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let request = createRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed
        }
        
        guard httpResponse.statusCode == 200 else {
            print("Erreur API: Status code \(httpResponse.statusCode)")
            throw APIError.requestFailed
        }
        
        do {
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            print("Films récupérés: \(movieResponse.results.count)")
            return movieResponse.results
        } catch {
            print("Erreur de décodage: \(error)")
            throw APIError.decodingFailed
        }
    }
    
    /// Recherche des films par titre
    func searchMovies(query: String) async throws -> [Movie] {
        let urlString = "\(baseURL)/search/movie?language=fr-FR&query=\(query)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let request = createRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed
        }
        
        guard httpResponse.statusCode == 200 else {
            print("❌ Status code: \(httpResponse.statusCode)")
            throw APIError.requestFailed
        }
        
        do {
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            print("✅ Films trouvés: \(movieResponse.results.count)")
            return movieResponse.results
        } catch {
            print("❌ Erreur de décodage: \(error)")
            // Affiche la réponse brute pour debug
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 JSON reçu: \(jsonString.prefix(200))")
            }
            throw APIError.decodingFailed
        }
    }
    
    /// Récupère les détails d'un film
    func fetchMovieDetails(id: Int) async throws -> Movie {
        let urlString = "\(baseURL)/movie/\(id)?language=fr-FR"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let request = createRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.requestFailed
        }
        
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            return movie
        } catch {
            print("❌ Erreur de décodage: \(error)")
            throw APIError.decodingFailed
        }
    }
}
