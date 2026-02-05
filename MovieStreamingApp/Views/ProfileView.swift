import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var editedEmail = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Section informations
                Section(header: Text("Informations personnelles")) {
                    if isEditing {
                        TextField("Nom", text: $editedName)
                        TextField("Email", text: $editedEmail)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    } else {
                        HStack {
                            Text("Nom")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(authViewModel.currentUser?.name ?? "")
                        }
                        
                        HStack {
                            Text("Email")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(authViewModel.currentUser?.email ?? "")
                        }
                    }
                }
                
                // Section statistiques
                Section(header: Text("Statistiques")) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Films favoris")
                        Spacer()
                        Text("\(authViewModel.currentUser?.favoriteMovieIds.count ?? 0)")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Message d'erreur
                if let error = authViewModel.errorMessage, isEditing {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // Actions
                Section {
                    if isEditing {
                        Button(action: {
                            saveProfile()
                        }) {
                            HStack {
                                Spacer()
                                Text("Enregistrer")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.green)
                        
                        Button(action: {
                            cancelEditing()
                        }) {
                            HStack {
                                Spacer()
                                Text("Annuler")
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.gray)
                    } else {
                        Button(action: {
                            startEditing()
                        }) {
                            HStack {
                                Spacer()
                                Text("Modifier le profil")
                                Spacer()
                            }
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.blue)
                    }
                    
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Se déconnecter")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.red)
                }
            }
            .navigationTitle("Profil")
            .alert("Succès", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func startEditing() {
        editedName = authViewModel.currentUser?.name ?? ""
        editedEmail = authViewModel.currentUser?.email ?? ""
        isEditing = true
    }
    
    private func cancelEditing() {
        isEditing = false
        authViewModel.errorMessage = nil
    }
    
    private func saveProfile() {
        if authViewModel.updateProfile(name: editedName, email: editedEmail) {
            isEditing = false
            alertMessage = "Profil mis à jour avec succès"
            showingAlert = true
        }
    }
}
