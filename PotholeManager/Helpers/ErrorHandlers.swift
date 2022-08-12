//
//  ErrorHandlers.swift
//  PotholeManager
//
//  Created by Alexis Manolis on 12/08/2022.
//

import Foundation
import UIKit

class ErrorHandlers: UIViewController {
    
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Error", message: "There was an error with the database", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        
        present(alert, animated: true)
        
    }
    
    func showError(message : String, errorLabel: UILabel) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
}
