//
//  PotholeManagerUITests.swift
//  PotholeManagerUITests
//
//  Created by Alexis Manolis on 10/08/2022.
//

import XCTest

class PotholeManagerUITests: XCTestCase {

    
    override func setUpWithError() throws {
 
        continueAfterFailure = false
    }
    
    
    func testSignUp() throws {

        let app = XCUIApplication()
        app.launch()
        
        let signUpInitial = app.buttons["Sign Up"]
        XCTAssertTrue(signUpInitial.exists)
        
        signUpInitial.tap()
        
        
        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists)
        
        firstNameTextField.tap()
        firstNameTextField.typeText("test")
        
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists)
        
        lastNameTextField.tap()
        lastNameTextField.typeText("tester")
        
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")

        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        
        let signUpButton = app.buttons["Sign Up"]
        XCTAssertTrue(signUpButton.exists)
        
        signUpButton.tap()
        
        sleep(5)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        
        welcomeLabel.tap()
                

    }

    func testLogin() throws {

        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(5)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        
        welcomeLabel.tap()
        
    }
    
    
    func testCreateReport() throws {

        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(10)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        welcomeLabel.tap()
        
        
        let makeReportButton = app.buttons["Make A Report"]
        XCTAssertTrue(makeReportButton.exists)
        makeReportButton.tap()
        
        
        let titleLabel = app.staticTexts["Report A Pothole"]
        XCTAssertTrue(titleLabel.exists)
        titleLabel.tap()
        
        
        let addPhotoLabel = app.staticTexts["Add Photo"]
        XCTAssertTrue(addPhotoLabel.exists)
        titleLabel.tap()
        
        
        let locationLabel = app.staticTexts["Location"]
        XCTAssertTrue(locationLabel.exists)
        locationLabel.tap()
        
        
        let streetTextField = app.textFields["Street"]
        XCTAssertTrue(streetTextField.exists)
        streetTextField.tap()
        streetTextField.typeText("Alikis Vougiouklaki 10")
        
        
        let cityTextField = app.textFields["City"]
        XCTAssertTrue(streetTextField.exists)
        cityTextField.tap()
        cityTextField.typeText("Limassol")
        
        
        let resDistrictTextField = app.textFields["Residential District"]
        XCTAssertTrue(resDistrictTextField.exists)
        resDistrictTextField.tap()
        resDistrictTextField.typeText("Ayia Fyla")
        
        
        let postcodeTextField = app.textFields["Postcode"]
        XCTAssertTrue(postcodeTextField.exists)
        postcodeTextField.tap()
        postcodeTextField.typeText("3117")
        
        
        titleLabel.tap()
        
        
        let dimensionsLabel = app.staticTexts["Dimensions"]
        XCTAssertTrue(dimensionsLabel.exists)
        dimensionsLabel.tap()
        
        
        let widthTextField = app.textFields["Width"]
        XCTAssertTrue(widthTextField.exists)
        widthTextField.tap()
        widthTextField.typeText("100")
        
        titleLabel.tap()
        
        let depthTextField = app.textFields["Depth"]
        XCTAssertTrue(depthTextField.exists)
        depthTextField.tap()
        depthTextField.typeText("2")
        
        titleLabel.tap()
        
        let detailsLabel = app.staticTexts["Further Details"]
        XCTAssertTrue(detailsLabel.exists)
        detailsLabel.tap()
        
        
        let enterDetailsTextField = app.textFields["Enter details"]
        XCTAssertTrue(enterDetailsTextField.exists)
        enterDetailsTextField.tap()
        enterDetailsTextField.typeText("UI testing writing this.")
        
        titleLabel.tap()
        
        
        let submitReportButton = app.buttons["Submit Report"]
        XCTAssertTrue(submitReportButton.exists)
        submitReportButton.tap()
        
        sleep(5)
        
        let map = app.maps.containing(.other, identifier:"Nicosia").element
        XCTAssertTrue(map.exists)
        map.tap()
            
    }
    
    func testSearchReport() throws {

        
        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(10)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        welcomeLabel.tap()
        
        
        let reportsButton = app.buttons["View Reports"]
        XCTAssertTrue(reportsButton.exists)
        reportsButton.tap()
        
        
        sleep(5)
        
        let enterAreaTextField = app.textFields["Enter Postcode"]
        XCTAssertTrue(enterAreaTextField.exists)
        enterAreaTextField.tap()
        enterAreaTextField.typeText("3117")
        
        let searchButton = app.buttons["Search"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        sleep(5)
        
   
        let postCodeLabelCell = app.tables.cells.element(boundBy: 0).staticTexts["3117"]
        XCTAssertTrue(postCodeLabelCell.exists)
        postCodeLabelCell.tap()
        
    }
    
    func testViewMap() {
        
        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(10)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        welcomeLabel.tap()
        
        
        let viewMapButton = app.buttons["View Map"]
        XCTAssertTrue(viewMapButton.exists)
        viewMapButton.tap()
        
        sleep(10)
        
        let map = app.maps.containing(.other, identifier:"Nicosia").element
        XCTAssertTrue(map.exists)
        map.tap()
    
    }
        

    func testReportLike() throws {

        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(10)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        welcomeLabel.tap()
        
        
        let reportsButton = app.buttons["View Reports"]
        XCTAssertTrue(reportsButton.exists)
        reportsButton.tap()
        
        
        sleep(10)
        
        
        let streetLabelCell = app.tables.cells.element(boundBy: 0).staticTexts["10 Alikis Vougiouklaki"]
        XCTAssertTrue(streetLabelCell.exists)
        streetLabelCell.tap()
        
        
        let likeButton = app.tables.children(matching: .cell).element(boundBy: 0).buttons["Like"].staticTexts["Like"]
        XCTAssertTrue(likeButton.exists)
        likeButton.tap()
        
        sleep(5)
        
        let likeLabel = app.tables.cells.element(boundBy: 0).staticTexts["3"]
        XCTAssertTrue(likeLabel.exists)
        likeLabel.tap()
    
    }
    
    func testReportUnlike() throws {

        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(10)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        welcomeLabel.tap()
        
        
        let reportsButton = app.buttons["View Reports"]
        XCTAssertTrue(reportsButton.exists)
        reportsButton.tap()
        
        
        sleep(10)
        
        let streetLabelCell = app.tables.cells.element(boundBy: 0).staticTexts["10 Alikis Vougiouklaki"]
        XCTAssertTrue(streetLabelCell.exists)
        streetLabelCell.tap()
        
        
        let unlikeButton = app.tables.children(matching: .cell).element(boundBy: 0).buttons["Unlike"].staticTexts["Unlike"]
        XCTAssertTrue(unlikeButton.exists)
        unlikeButton.tap()
        
        sleep(10)
        
        let likeLabel = app.tables.cells.element(boundBy: 0).staticTexts["2"]
        XCTAssertTrue(likeLabel.exists)
        likeLabel.tap()
    
    }
    
    
    func testViewMyReports() {
        
        let app = XCUIApplication()
        app.launch()
        
        let initialLoginButton = app.buttons["Login"]
        XCTAssertTrue(initialLoginButton.exists)
        
        initialLoginButton.tap()
        
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        emailTextField.tap()
        emailTextField.typeText("tester@gmail.com")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("Password123!")
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists)
        
        loginButton.tap()
        
        sleep(10)
        
        let homeLabel = app.staticTexts["Home"]
        XCTAssertTrue(homeLabel.exists)
        homeLabel.tap()
 
        
        let welcomeLabel = app.staticTexts["Welcome test"]
        XCTAssertTrue(welcomeLabel.exists)
        welcomeLabel.tap()
        
        
        let myReportsButton = app.buttons["My Reports"]
        XCTAssertTrue(myReportsButton.exists)
        myReportsButton.tap()
        
        let title = app.staticTexts["My Reports"]
        XCTAssertTrue(title.exists)
        title.tap()
        
        sleep(10)
        
        let streetLabelCell = app.tables.cells.element(boundBy: 0).staticTexts["Alikis Vougiouklaki 10"]
        XCTAssertTrue(streetLabelCell.exists)
        streetLabelCell.tap()
        
        let cityLabelCell = app.tables.cells.element(boundBy: 0).staticTexts["Limassol"]
        XCTAssertTrue(cityLabelCell.exists)
        cityLabelCell.tap()
        
    
        let deleteButton = app.tables.children(matching: .cell).element(boundBy: 0).buttons["Delete"].staticTexts["Delete"]
        XCTAssertTrue(deleteButton.exists)
        deleteButton.tap()
        
    }

}
