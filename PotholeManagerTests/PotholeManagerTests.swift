//
//  PotholeManagerTests.swift
//  PotholeManagerTests
//
//  Created by Alexis Manolis on 08/08/2022.
//

import XCTest

class PotholeManagerTests: XCTestCase {
    
    let mapVC = MapViewController()
    let signUpVC = SignUpViewController()
  
    
    func testPasswordNotValid() {
        
        let result = signUpVC.isPasswordValid("password")
        XCTAssertFalse(result)

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
    
    
    func testCheckExtremeSeverity() {
        
        let result = mapVC.checkSeverity(count: 20)
        XCTAssertEqual(result, "Extreme")
        
    }
    
    
    func testCheckExtremeSeverityBounds() {
        
        let result = mapVC.checkSeverity(count: 11)
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

}
