# MovieStreamingApp

Application mobile iOS de streaming de films développée en Swift et SwiftUI.

## Description

MovieStreamingApp est une application permettant aux utilisateurs de consulter un catalogue de films, de gérer leurs favoris et leur profil personnel. L'application utilise l'API TMDB (The Movie Database) pour récupérer les informations des films.

## Fonctionnalités

### ✅ Authentification
- Création de compte utilisateur
- Connexion avec email et mot de passe
- Déconnexion
- Gestion de session persistante
- Messages d'erreur détaillés

### ✅ Gestion du profil
- Affichage des informations utilisateur
- Modification du nom et de l'email
- Statistiques (nombre de favoris)
- Sauvegarde persistante des modifications

### ✅ Catalogue de films
- Récupération des films populaires depuis l'API TMDB
- Affichage en grille avec images
- Recherche de films
- Note et titre pour chaque film
- Chargement asynchrone des images

### ✅ Détail d'un film
- Image haute résolution
- Description complète
- Note moyenne
- Date de sortie
- Bouton d'ajout/suppression des favoris

### ✅ Gestion des favoris
- Ajout/suppression de films aux favoris
- Liste des favoris propre à chaque utilisateur
- Persistance entre les sessions
- Chargement des détails des films favoris

### ✅ Navigation
- TabView avec 3 onglets : Films, Favoris, Profil
- NavigationStack pour la navigation hiérarchique
- Accès conditionnel selon l'état de connexion

## Architecture

L'application suit l'architecture **MVVM (Model-View-ViewModel)** :

### Models
- **User.swift** : Modèle utilisateur avec identifiants et favoris
- **Movie.swift** : Modèle film avec données de l'API TMDB

### Views
- **LoginView.swift** : Écran de connexion
- **RegisterView.swift** : Écran d'inscription
- **MainTabView.swift** : TabView principale
- **MovieListView.swift** : Liste des films
- **MovieDetailView.swift** : Détails d'un film
- **FavoritesView.swift** : Liste des favoris
- **ProfileView.swift** : Profil utilisateur

### ViewModels
- **AuthViewModel.swift** : Gestion de l'authentification et du profil
- **MovieViewModel.swift** : Gestion des films et recherche

### Services
- **PersistenceService.swift** : Persistance locale avec UserDefaults
- **MovieAPIService.swift** : Communication avec l'API TMDB

## Prérequis

- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**
- **Clé API TMDB** (gratuite)

## Installation

### 1. Cloner le projet

```bash
git clone <repository-url>
cd MovieStreamingApp
```

### 2. Obtenir une clé API TMDB

1. Créer un compte sur [The Movie Database](https://www.themoviedb.org/)
2. Aller dans les paramètres du compte → API
3. Demander une clé API (gratuit)
4. Copier la clé API (v3 auth)

### 3. Configurer la clé API

Ouvrir le fichier `Services/MovieAPIService.swift` et remplacer :

```swift
private let apiKey = "YOUR_TMDB_API_KEY"
```

Par votre clé API :

```swift
private let apiKey = "votre_clé_api_ici"
```

### 4. Lancer l'application

1. Ouvrir le projet dans Xcode
2. Sélectionner un simulateur iOS (iPhone 15 Pro recommandé)
3. Appuyer sur **Run** (⌘R)

## Utilisation

### Première utilisation

1. **Créer un compte**
   - Ouvrir l'application
   - Cliquer sur "Pas encore de compte ? S'inscrire"
   - Remplir le formulaire d'inscription
   - Cliquer sur "S'inscrire"

2. **Se connecter**
   - Entrer votre email et mot de passe
   - Cliquer sur "Se connecter"

3. **Parcourir les films**
   - L'onglet Films affiche les films populaires
   - Utiliser la barre de recherche pour trouver un film spécifique
   - Cliquer sur un film pour voir les détails

4. **Ajouter aux favoris**
   - Dans la page de détail d'un film
   - Cliquer sur "Ajouter aux favoris"
   - Le film apparaîtra dans l'onglet Favoris

5. **Gérer son profil**
   - Aller dans l'onglet Profil
   - Cliquer sur "Modifier le profil"
   - Modifier le nom ou l'email
   - Cliquer sur "Enregistrer"

## Tests unitaires

L'application inclut des tests unitaires pour les composants principaux :

- **UserTests.swift** : Tests du modèle User
- **AuthViewModelTests.swift** : Tests d'authentification et gestion utilisateur
- **PersistenceServiceTests.swift** : Tests de persistance des données

### Exécuter les tests

Dans Xcode :
- Appuyer sur **⌘U** pour lancer tous les tests
- Ou aller dans **Product** → **Test**

## Structure du projet

```
MovieStreamingApp/
├── MovieStreamingApp.swift          # Point d'entrée de l'app
├── ContentView.swift                # Vue racine
├── Models/
│   ├── User.swift                   # Modèle utilisateur
│   └── Movie.swift                  # Modèle film
├── Views/
│   ├── LoginView.swift              # Connexion
│   ├── RegisterView.swift           # Inscription
│   ├── MainTabView.swift            # Navigation principale
│   ├── MovieListView.swift          # Liste des films
│   ├── MovieDetailView.swift        # Détails d'un film
│   ├── FavoritesView.swift          # Favoris
│   └── ProfileView.swift            # Profil
├── ViewModels/
│   ├── AuthViewModel.swift          # ViewModel authentification
│   └── MovieViewModel.swift         # ViewModel films
├── Services/
│   ├── PersistenceService.swift     # Persistance locale
│   └── MovieAPIService.swift        # API TMDB
└── Tests/
    ├── UserTests.swift
    ├── AuthViewModelTests.swift
    └── PersistenceServiceTests.swift
```

## API utilisée

**The Movie Database (TMDB) API**
- Documentation : https://developers.themoviedb.org/3
- Version : v3
- Langue : Français (fr-FR)
- Endpoints utilisés :
  - `/movie/popular` : Films populaires
  - `/search/movie` : Recherche de films
  - `/movie/{id}` : Détails d'un film

## Bonnes pratiques implémentées

### Code
- ✅ Architecture MVVM stricte
- ✅ Séparation des responsabilités
- ✅ Code organisé et lisible
- ✅ Gestion des erreurs
- ✅ Async/await pour les appels réseau
- ✅ Utilisation de @Published pour la réactivité

### UI/UX
- ✅ Interface cohérente et intuitive
- ✅ Feedback visuel (loading, erreurs)
- ✅ Chargement asynchrone des images
- ✅ Messages d'erreur clairs
- ✅ Navigation fluide

### Persistance
- ✅ UserDefaults pour les données utilisateur
- ✅ Sauvegarde automatique
- ✅ Session persistante
- ✅ Favoris par utilisateur

### Tests
- ✅ Tests unitaires pour les modèles
- ✅ Tests des ViewModels
- ✅ Tests des services
- ✅ Couverture des cas limites

## Améliorations possibles

- [ ] Recherche avec filtres avancés
- [ ] Pagination pour charger plus de films
- [ ] Mode hors ligne avec cache
- [ ] Animations SwiftUI avancées
- [ ] Synchronisation cloud (iCloud)
- [ ] Support du mode sombre
- [ ] Catégories de films
- [ ] Partage de films
- [ ] Historique de visionnage
- [ ] Notifications

## Auteur

Projet réalisé dans le cadre d'un exercice académique Swift/SwiftUI.

## Licence

Ce projet est à usage éducatif uniquement.

## Remerciements

- [The Movie Database (TMDB)](https://www.themoviedb.org/) pour l'API gratuite
- Apple pour Swift et SwiftUI
