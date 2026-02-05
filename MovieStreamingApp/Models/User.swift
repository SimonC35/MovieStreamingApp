import Foundation

struct User: Codable, Identifiable {
    var id: UUID
    var name: String
    var email: String
    var password: String
    var favoriteMovieIds: [Int]
    
    init(id: UUID = UUID(), name: String, email: String, password: String, favoriteMovieIds: [Int] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.favoriteMovieIds = favoriteMovieIds
    }
}
