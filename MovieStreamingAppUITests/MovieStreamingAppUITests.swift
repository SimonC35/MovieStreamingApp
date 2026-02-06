import XCTest

final class MovieStreamingAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Si un test échoue, on arrête tout pour ne pas perdre de temps
        continueAfterFailure = false
    }
    
    // MARK: - 1. PARCOURS COMPLET (LE PLUS IMPORTANT)
    
    @MainActor
    func test_full_user_journey() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UI_TEST")
        app.launch()

        // --- PHASE : INSCRIPTION ---
        let goToRegister = app.buttons["go_to_register"]
        XCTAssertTrue(goToRegister.waitForExistence(timeout: 5), "Bouton d'inscription introuvable")
        goToRegister.tap()

        let nameField = app.textFields["register_name_field"]
        let regEmailField = app.textFields["register_email_field"]
        let regPasswordField = app.secureTextFields["register_password_field"]
        let confirmField = app.secureTextFields["register_confirm_password_field"]
        let signUpButton = app.buttons["register_submit_button"]

        // Générer un email unique pour éviter l'erreur "Compte déjà existant"
        let testEmail = "test_\(Int(Date().timeIntervalSince1970))@test.com"
        let testPassword = "Password123!"

        nameField.tap()
        nameField.typeText("Jean Test")
        
        regEmailField.tap()
        regEmailField.typeText(testEmail)
        
        regPasswordField.tap()
        regPasswordField.typeText(testPassword)
        
        confirmField.tap()
        confirmField.typeText(testPassword)

        signUpButton.tap()

        // Valider l'alerte
        let alert = app.alerts["Inscription réussie"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "L'alerte de succès n'est pas apparue")
        alert.buttons["OK"].tap()

        // --- PHASE : CONNEXION ---
        let loginEmail = app.textFields["login_email"]
        let loginPass = app.secureTextFields["login_password"]
        let loginBtn = app.buttons["login_button"]

        XCTAssertTrue(loginEmail.waitForExistence(timeout: 5), "Retour au login échoué")
        
        loginEmail.tap()
        loginEmail.typeText(testEmail)
        
        loginPass.tap()
        loginPass.typeText(testPassword)

        loginBtn.tap()

        // --- VERIFICATION FINALE ---
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 10), "La TabBar n'est pas apparue après le login.")
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
