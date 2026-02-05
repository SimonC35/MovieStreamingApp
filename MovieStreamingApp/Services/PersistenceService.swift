import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    
    private let userDefaultsKey = "users"
    private let currentUserKey = "currentUser"
    
    private init() {}
        
    func saveUser(_ user: User) {
        var users = getAllUsers()
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        } else {
            users.append(user)
        }
        
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func getAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let users = try? JSONDecoder().decode([User].self, from: data) else {
            return []
        }
        return users
    }
    
    func getUser(email: String, password: String) -> User? {
        let users = getAllUsers()
        return users.first { $0.email == email && $0.password == password }
    }
    
    func userExists(email: String) -> Bool {
        let users = getAllUsers()
        return users.contains { $0.email == email }
    }
        
    func saveCurrentUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: currentUserKey)
        }
    }
    
    func getCurrentUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func clearCurrentUser() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
        
    func addFavorite(movieId: Int, for user: User) -> User {
        var updatedUser = user
        if !updatedUser.favoriteMovieIds.contains(movieId) {
            updatedUser.favoriteMovieIds.append(movieId)
            saveUser(updatedUser)
            saveCurrentUser(updatedUser)
        }
        return updatedUser
    }
    
    func removeFavorite(movieId: Int, for user: User) -> User {
        var updatedUser = user
        updatedUser.favoriteMovieIds.removeAll { $0 == movieId }
        saveUser(updatedUser)
        saveCurrentUser(updatedUser)
        return updatedUser
    }
}
