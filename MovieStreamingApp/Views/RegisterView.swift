import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 10) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 70))
                    .foregroundColor(.red)
                
                Text("Créer un compte")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.bottom, 30)
            
            VStack(spacing: 15) {
                TextField("Nom", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.name)
                    .accessibilityIdentifier("register_name_field") // ID de test
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .accessibilityIdentifier("register_email_field") // ID de test
                
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.newPassword)
                    .accessibilityIdentifier("register_password_field") // ID de test
                
                SecureField("Confirmer le mot de passe", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.newPassword)
                    .accessibilityIdentifier("register_confirm_password_field") // ID de test
            }
            .padding(.horizontal, 30)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal, 30)
                    .accessibilityIdentifier("register_error_message")
            }
            
            Button(action: {
                registerUser()
            }) {
                Text("S'inscrire")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            .accessibilityIdentifier("register_submit_button") // ID de test
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Inscription réussie", isPresented: $showingAlert) {
            Button("OK") {
                dismiss()
            }
            .accessibilityIdentifier("alert_ok_button")
        } message: {
            Text(alertMessage)
        }
    }
    
    private func registerUser() {
        guard password == confirmPassword else {
            authViewModel.errorMessage = "Les mots de passe ne correspondent pas"
            return
        }
        
        if authViewModel.register(name: name, email: email, password: password) {
            alertMessage = "Votre compte a été créé avec succès."
            showingAlert = true
        }
    }
}
