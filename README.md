# MovieStreamingApp

Application mobile iOS de streaming de films développée en Swift et SwiftUI.

## Description

MovieStreamingApp est une application permettant aux utilisateurs de consulter un catalogue de films, de gérer leurs favoris et leur profil personnel. L'application utilise l'API TMDB (The Movie Database) pour récupérer les informations des films.

## Prérequis

- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**
- **Clé API TMDB** (gratuite)

## Installation

### 1. Cloner le projet

```bash
git clone
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
2. Sélectionner un simulateur iOS
3. Appuyer sur **Run** (⌘R)

## Structure du projet

```
MovieStreamingApp/
├── MovieStreamingApp.swift          # Point d'entrée de l'app
├── ContentView.swift                # Vue racine
├── Models/
├── Views/
├── ViewModels/
├── Services/
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

## Auteur

Projet réalisé dans le cadre d'un exercice académique Swift/SwiftUI.

## Licence

Ce projet est à usage éducatif uniquement.
