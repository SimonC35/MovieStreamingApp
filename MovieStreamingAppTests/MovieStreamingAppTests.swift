//
//  MovieStreamingAppTests.swift
//  MovieStreamingAppTests
//

import Testing
@testable import MovieStreamingApp
import Foundation

struct MovieStreamingAppTests {
    
    func resetUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    // MARK: - AuthViewModel Tests
    
    @Test
    func register_success() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        let result = viewModel.register(
            name: "John",
            email: "john@test.com",
            password: "123456"
        )
        
        #expect(result == true)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test
    func register_fails_with_empty_fields() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        let result = viewModel.register(
            name: "",
            email: "",
            password: ""
        )
        
        #expect(result == false)
        #expect(viewModel.errorMessage == "Tous les champs sont requis")
    }
    
    @Test
    func register_fails_with_invalid_email() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        let result = viewModel.register(
            name: "John",
            email: "john",
            password: "123456"
        )
        
        #expect(result == false)
        #expect(viewModel.errorMessage == "Email invalide")
    }
    
    @Test
    func login_success() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        _ = viewModel.register(
            name: "John",
            email: "john@test.com",
            password: "123456"
        )
        
        let loginResult = viewModel.login(
            email: "john@test.com",
            password: "123456"
        )
        
        #expect(loginResult == true)
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.currentUser != nil)
    }
    
    @Test
    func login_fails_with_wrong_password() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        _ = viewModel.register(
            name: "John",
            email: "john@test.com",
            password: "123456"
        )
        
        let loginResult = viewModel.login(
            email: "john@test.com",
            password: "wrong"
        )
        
        #expect(loginResult == false)
        #expect(viewModel.errorMessage == "Email ou mot de passe incorrect")
    }
    
    @Test
    func logout_clears_user() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        _ = viewModel.register(
            name: "John",
            email: "john@test.com",
            password: "123456"
        )
        
        _ = viewModel.login(
            email: "john@test.com",
            password: "123456"
        )
        
        viewModel.logout()
        
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.currentUser == nil)
    }
    
    @Test
    func add_and_remove_favorite_movie() async {
        resetUserDefaults()
        let viewModel = AuthViewModel()
        
        _ = viewModel.register(
            name: "John",
            email: "john@test.com",
            password: "123456"
        )
        
        _ = viewModel.login(
            email: "john@test.com",
            password: "123456"
        )
        
        viewModel.addFavorite(movieId: 42)
        #expect(viewModel.isFavorite(movieId: 42) == true)
        
        viewModel.removeFavorite(movieId: 42)
        #expect(viewModel.isFavorite(movieId: 42) == false)
    }
    
    // MARK: - MovieViewModel Tests (API réelle)
    
    @Test
    func fetch_popular_movies_returns_results() async {
        let viewModel = MovieViewModel()
        
        viewModel.fetchPopularMovies()
        
        // attendre la réponse API
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.movies.isEmpty == false)
    }
}
