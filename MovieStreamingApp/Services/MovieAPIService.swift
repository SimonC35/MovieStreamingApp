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
    /*
    func fetchPopularMovies(page: Int = 1) async throws -> Data {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(
            "Bearer YOUR_TMDB_BEARER_TOKEN",
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
*/
    
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
        //let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?language=fr-FR&query=\(query)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let request = createRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.requestFailed
        }
        print("dedede")
        print("de")
        do {
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch {
            print("❌ Erreur de décodage: \(error)")
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
