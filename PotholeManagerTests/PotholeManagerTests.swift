//
//  PotholeManagerTests.swift
//  PotholeManagerTests
//
//  Created by Alexis Manolis on 08/08/2022.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
import Firebase


class PotholeManagerTests: XCTestCase {
    
    let mapVC = MapViewController()
    let signUpVC = SignUpViewController()
    let reportVC = ReportViewController()
    let authManager = AuthenticationManager()
    
    
    func testPasswordNotValid() {
        
        let result = signUpVC.isPasswordValid("password")
        XCTAssertFalse(result)

    }
    
    func test() {
        
        
        
        // Creating user
        Auth.auth().createUser(withEmail: "email@gmail.com", password: "password123!") { (result, err) in
            
            // Check if errors
            if err != nil {
                // Error present
                let test = "error"
                XCTAssertEqual(test, "true")
            }
            else {
                
                // If no errors then create user and add to database.
                let db = Firestore.firestore()
                
                // Add a new user to the database.
                db.collection("users").addDocument(data: ["firstname":"name", "lastname":"name", "uid":result!.user.uid]) { (error) in
                    
                    if error != nil {
                        let test = "error"
                        XCTAssertEqual(test, "true")
                    }
                }
                let test = "true"
                XCTAssertEqual(test, "error")
            }
        }
        
        
    }
    
    
    func testPasswordValid() {
        
        let result = signUpVC.isPasswordValid("Password1234!@")
        XCTAssertTrue(result)

    }
    
    func testSignUpFieldsSuccess() {
        
        let signUpFields = SignUpFields(firstName: "test",
                                        lastName: "tester",
                                        email: "testemail",
                                        password: "password123!")
        
        let result = signUpVC.validateFields(signUpFields: signUpFields)
        XCTAssertEqual(result, nil)
    }
    
    
    func testSignUpFieldsFailEmpty() {
        
        let signUpFields = SignUpFields(firstName: "",
                                        lastName: "test",
                                        email: "test",
                                        password: "test")
        
        let result = signUpVC.validateFields(signUpFields: signUpFields)
        XCTAssertEqual(result, "Please fill in all fields")
    }
    
    func testSignUpFieldsFailPassword() {
        
        let signUpFields = SignUpFields(firstName: "test",
                                        lastName: "test",
                                        email: "test",
                                        password: "test")
        
        let result = signUpVC.validateFields(signUpFields: signUpFields)
        XCTAssertEqual(result, "Password must have 8 characters, at least one special character and number.")
    }
/*
    func testSignUp() {
        
        signUp.signUpUser(email: "", password: "", firstName: "Guess", lastName: "Who") { result in
            
            XCTAssertTrue(result)
        }
        
    }
  */
    
    func testCheckModerateSeverity() {
    
        let result1 = mapVC.checkSeverity(count: 1)
        XCTAssertEqual(result1, "Moderate")
        
    }
    
    func testCheckModerateSeverityBounds() {
    
        let result1 = mapVC.checkSeverity(count: 2)
        XCTAssertEqual(result1, "Moderate")
        
    }
    
    func testCheckBadSeverity() {
        
        let result = mapVC.checkSeverity(count: 5)
        XCTAssertEqual(result, "Bad")
    }
    
    
    
    func testCheckBadSeverityBounds() {
        
        let result = mapVC.checkSeverity(count: 10)
        XCTAssertEqual(result, "Bad")
    }
    
    
    func testCheckExtremeSeverityBounds() {
        
        let result = mapVC.checkSeverity(count: 11)
        XCTAssertEqual(result, "Extreme")
        
    }
    
    
    func testCheckExtremeSeverity() {
        
        let result = mapVC.checkSeverity(count: 20)
        XCTAssertEqual(result, "Extreme")
        
    }
    
    func testCheckTwoDuplicates() {
        
        let mapVC = MapViewController()
        
        let locations = [Location(id: "icva2", longitude: 2, latitude: 2, streetName: "test"),
                         Location(id: "242f", longitude: 1, latitude: 2.2, streetName: "test"),
                         Location(id: "2", longitude: 5, latitude: 2.2, streetName: "not test")]
        
        let result = mapVC.checkDuplicates(locations: locations, streetName: "test")
        XCTAssertEqual(result, 2)
    }
    
    
    func testCheckFourDuplicates() {
        
        let mapVC = MapViewController()
        
        let locations = [Location(id: "icva2", longitude: 2, latitude: 2, streetName: "test"),
                         Location(id: "242f", longitude: 1, latitude: 2.2, streetName: "test"),
                         Location(id: "2", longitude: 5, latitude: 2.2, streetName: "not test"),
                         Location(id: "2f", longitude: 1.1, latitude: 2.2, streetName: "test"),
                         Location(id: "2456f", longitude: 5.1, latitude: 2.2, streetName: "te"),
                         Location(id: "212d", longitude: 1, latitude: 2.2, streetName: "test"),
                         Location(id: "12f", longitude: 1, latitude: 2.2, streetName: "tet")]
        
        let result = mapVC.checkDuplicates(locations: locations, streetName: "test")
        XCTAssertEqual(result, 4)
    }
    
    
    func testCheckNoDuplicates() {
        
        let mapVC = MapViewController()
        
        let locations = [Location(id: "icva2", longitude: 2, latitude: 2, streetName: "testa"),
                         Location(id: "242f", longitude: 1, latitude: 2.2, streetName: "tests"),
                         Location(id: "2", longitude: 5, latitude: 2.2, streetName: "not test"),
                         Location(id: "2f", longitude: 1.1, latitude: 2.2, streetName: "test")]
        
        let result = mapVC.checkDuplicates(locations: locations, streetName: "test")
        XCTAssertEqual(result, 1)
    }

    /*
    func testCheckSetAddressCoordinates() {
        
        let address = "Alikis Vougiouklaki 10"
        
        reportVC.setAddressCoordinates(with: address) { result in
            XCTAssertEqual(result, true)
        }
    }
    
    
    func testCheckSetCoordinatesFail() {
        
        let address = "Alikis Vougiouklaki"
        
        reportVC.setAddressCoordinates(with: address) { result in
            XCTAssertEqual(result, true)
        }
    }
 
    func testAddReport() {
        
        let reportVC = ReportViewController()
        
        let report = ReportDetails(street: "Alikis Vougiouklaki 10", city: "Limassol", residentialDistrict: "Ayia Fyla", postcode: "3117", width: "30", depth: "2", enterDetails: "No Comment", uid: "asdas4444232rf", email: "testeee@gmail.com", address: "10 Alikis Vougiouklaki")
                         
        reportVC.addReportToDatabase(globalPath: "2e2fdag3dd", report: report, getLocationTapped: false) { result, postid in
            
            print("The result is \(result)")
            XCTAssertFalse(result)
        }
  
    }
*/
}
