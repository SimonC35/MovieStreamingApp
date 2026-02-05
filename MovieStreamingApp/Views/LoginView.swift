import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegister = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // Logo/Titre
                VStack(spacing: 10) {
                    Image(systemName: "film.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    
                    Text("MovieStream")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 40)
                
                // Champs de connexion
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)
                }
                .padding(.horizontal, 30)
                
                // Message d'erreur
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 30)
                }
                
                // Bouton de connexion
                Button(action: {
                    _ = authViewModel.login(email: email, password: password)
                }) {
                    Text("Se connecter")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                // Lien vers l'inscription
                Button(action: {
                    showingRegister = true
                }) {
                    Text("Pas encore de compte ? S'inscrire")
                        .foregroundColor(.red)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .navigationDestination(isPresented: $showingRegister) {
                RegisterView()
            }
        }
    }
}
