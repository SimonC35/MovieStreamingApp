//import XCTest
@testable import MovieStreamingApp

final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AuthViewModel()
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "users")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testRegisterSuccess() {
        let result = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        
        XCTAssertTrue(result)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testRegisterWithEmptyFields() {
        let result = viewModel.register(name: "", email: "john@example.com", password: "password123")
        
        XCTAssertFalse(result)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testRegisterWithInvalidEmail() {
        let result = viewModel.register(name: "John Doe", email: "invalidemail", password: "password123")
        
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.errorMessage, "Email invalide")
    }
    
    func testRegisterWithShortPassword() {
        let result = viewModel.register(name: "John Doe", email: "john@example.com", password: "123")
        
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.errorMessage, "Le mot de passe doit contenir au moins 6 caractères")
    }
    
    func testRegisterDuplicateEmail() {
        _ = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        let result = viewModel.register(name: "Jane Doe", email: "john@example.com", password: "password456")
        
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.errorMessage, "Un compte existe déjà avec cet email")
    }
    
    func testLoginSuccess() {
        _ = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        viewModel.logout()
        
        let result = viewModel.login(email: "john@example.com", password: "password123")
        
        XCTAssertTrue(result)
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoginWithWrongPassword() {
        _ = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        viewModel.logout()
        
        let result = viewModel.login(email: "john@example.com", password: "wrongpassword")
        
        XCTAssertFalse(result)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.errorMessage, "Email ou mot de passe incorrect")
    }
    
    func testLogout() {
        _ = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        _ = viewModel.login(email: "john@example.com", password: "password123")
        
        viewModel.logout()
        
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }
    
    func testAddFavorite() {
        _ = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        _ = viewModel.login(email: "john@example.com", password: "password123")
        
        viewModel.addFavorite(movieId: 123)
        
        XCTAssertTrue(viewModel.isFavorite(movieId: 123))
        XCTAssertEqual(viewModel.currentUser?.favoriteMovieIds.count, 1)
    }
    
    func testRemoveFavorite() {
        _ = viewModel.register(name: "John Doe", email: "john@example.com", password: "password123")
        _ = viewModel.login(email: "john@example.com", password: "password123")
        
        viewModel.addFavorite(movieId: 123)
        viewModel.removeFavorite(movieId: 123)
        
        XCTAssertFalse(viewModel.isFavorite(movieId: 123))
        XCTAssertEqual(viewModel.currentUser?.favoriteMovieIds.count, 0)
    }
}
