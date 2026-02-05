import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let imagePath: String?
    let note: Double
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imagePath = "poster_path"
        case note = "vote_average"
        case releaseDate = "release_date"
    }
    
    var posterURL: URL? {
        guard let imagePath = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
    }
    
    var ratingText: String {
        return String(format: "%.1f", note)
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
}
