//
//  Extensions.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit

extension UIViewController {
    
    func someWrongAlert(_ title: String ,_ message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
     }
    
    func searchNewCityAlert(completion:@escaping ((String) -> Void)) {
        let alert = UIAlertController(
                    title: nil,
                    message: "Enter term for search new city  in data bace",
                    preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "search term"
        }
        alert.addAction(.init(title: "cancel", style: .destructive))
        alert.addAction(.init(title: "search", style: .default) { _ in
            let text = alert.textFields?.first?.text ?? ""
            completion(text)
        })
        self.present(alert, animated: true)
        
    }
}

func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}
