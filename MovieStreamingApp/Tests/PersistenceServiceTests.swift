//import XCTest
@testable import MovieStreamingApp

final class PersistenceServiceTests: XCTestCase {
    var persistenceService: PersistenceService!
    
    override func setUp() {
        super.setUp()
        persistenceService = PersistenceService.shared
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "users")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    func testSaveAndRetrieveUser() {
        let user = User(name: "Test User", email: "test@example.com", password: "password123")
        
        persistenceService.saveUser(user)
        let users = persistenceService.getAllUsers()
        
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Test User")
        XCTAssertEqual(users.first?.email, "test@example.com")
    }
    
    func testUpdateExistingUser() {
        var user = User(name: "Test User", email: "test@example.com", password: "password123")
        persistenceService.saveUser(user)
        
        user.name = "Updated Name"
        persistenceService.saveUser(user)
        
        let users = persistenceService.getAllUsers()
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Updated Name")
    }
    
    func testUserExists() {
        let user = User(name: "Test User", email: "test@example.com", password: "password123")
        persistenceService.saveUser(user)
        
        XCTAssertTrue(persistenceService.userExists(email: "test@example.com"))
        XCTAssertFalse(persistenceService.userExists(email: "notexist@example.com"))
    }
    
    func testGetUserWithCredentials() {
        let user = User(name: "Test User", email: "test@example.com", password: "password123")
        persistenceService.saveUser(user)
        
        let retrievedUser = persistenceService.getUser(email: "test@example.com", password: "password123")
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser?.name, "Test User")
        
        let invalidUser = persistenceService.getUser(email: "test@example.com", password: "wrongpassword")
        XCTAssertNil(invalidUser)
    }
    
    func testCurrentUserSession() {
        let user = User(name: "Test User", email: "test@example.com", password: "password123")
        
        persistenceService.saveCurrentUser(user)
        let currentUser = persistenceService.getCurrentUser()
        
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.name, "Test User")
        
        persistenceService.clearCurrentUser()
        let clearedUser = persistenceService.getCurrentUser()
        XCTAssertNil(clearedUser)
    }
    
    func testAddFavorite() {
        let user = User(name: "Test User", email: "test@example.com", password: "password123")
        persistenceService.saveUser(user)
        
        let updatedUser = persistenceService.addFavorite(movieId: 123, for: user)
        
        XCTAssertTrue(updatedUser.favoriteMovieIds.contains(123))
    }
    
    func testRemoveFavorite() {
        var user = User(name: "Test User", email: "test@example.com", password: "password123", favoriteMovieIds: [123, 456])
        persistenceService.saveUser(user)
        
        user = persistenceService.removeFavorite(movieId: 123, for: user)
        
        XCTAssertFalse(user.favoriteMovieIds.contains(123))
        XCTAssertTrue(user.favoriteMovieIds.contains(456))
    }
}
