//
//  Extensions.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit

extension UIViewController {
    
    func someWrongAlert(_ title: String ,_ message: String, completion:@escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            completion()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
     }
}

func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
