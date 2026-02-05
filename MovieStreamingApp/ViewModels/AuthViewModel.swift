import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    private let persistenceService = PersistenceService.shared
    
    init() {
        checkExistingSession()
    }
    
    func checkExistingSession() {
        if let user = persistenceService.getCurrentUser() {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    func register(name: String, email: String, password: String) -> Bool {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Tous les champs sont requis"
            return false
        }
        
        guard email.contains("@") else {
            errorMessage = "Email invalide"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Le mot de passe doit contenir au moins 6 caractères"
            return false
        }
        
        if persistenceService.userExists(email: email) {
            errorMessage = "Un compte existe déjà avec cet email"
            return false
        }
        
        let newUser = User(name: name, email: email, password: password)
        persistenceService.saveUser(newUser)
        
        errorMessage = nil
        return true
    }
    
    func login(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email et mot de passe requis"
            return false
        }
        
        if let user = persistenceService.getUser(email: email, password: password) {
            self.currentUser = user
            self.isAuthenticated = true
            persistenceService.saveCurrentUser(user)
            errorMessage = nil
            return true
        } else {
            errorMessage = "Email ou mot de passe incorrect"
            return false
        }
    }
    
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
        persistenceService.clearCurrentUser()
    }
    
    func updateProfile(name: String, email: String) -> Bool {
        guard var user = currentUser else { return false }
        
        guard !name.isEmpty, !email.isEmpty else {
            errorMessage = "Tous les champs sont requis"
            return false
        }
        
        guard email.contains("@") else {
            errorMessage = "Email invalide"
            return false
        }
        
        // Vérifier si l'email existe déjà (sauf si c'est le même)
        if email != user.email && persistenceService.userExists(email: email) {
            errorMessage = "Cet email est déjà utilisé"
            return false
        }
        
        user.name = name
        user.email = email
        
        persistenceService.saveUser(user)
        persistenceService.saveCurrentUser(user)
        self.currentUser = user
        errorMessage = nil
        return true
    }
    
    func addFavorite(movieId: Int) {
        guard let user = currentUser else { return }
        let updatedUser = persistenceService.addFavorite(movieId: movieId, for: user)
        self.currentUser = updatedUser
    }
    
    func removeFavorite(movieId: Int) {
        guard let user = currentUser else { return }
        let updatedUser = persistenceService.removeFavorite(movieId: movieId, for: user)
        self.currentUser = updatedUser
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return currentUser?.favoriteMovieIds.contains(movieId) ?? false
    }
}
