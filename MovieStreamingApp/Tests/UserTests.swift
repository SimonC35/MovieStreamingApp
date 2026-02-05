import XCTest
@testable import MovieStreamingApp

final class UserTests: XCTestCase {
    
    func testUserInitialization() {
        let user = User(name: "Test User", email: "test@example.com", password: "password123")
        
        XCTAssertNotNil(user.id)
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.password, "password123")
        XCTAssertTrue(user.favoriteMovieIds.isEmpty)
    }
    
    func testUserCodable() throws {
        let user = User(name: "Test User", email: "test@example.com", password: "password123", favoriteMovieIds: [1, 2, 3])
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        
        let decoder = JSONDecoder()
        let decodedUser = try decoder.decode(User.self, from: data)
        
        XCTAssertEqual(user.id, decodedUser.id)
        XCTAssertEqual(user.name, decodedUser.name)
        XCTAssertEqual(user.email, decodedUser.email)
        XCTAssertEqual(user.favoriteMovieIds, decodedUser.favoriteMovieIds)
    }
}
