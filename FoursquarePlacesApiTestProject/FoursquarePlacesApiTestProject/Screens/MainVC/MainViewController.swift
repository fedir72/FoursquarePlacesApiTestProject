//
//  MainViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 10.09.2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    private var categoryState = false
     var currentLocation = CLLocation() {
        didSet { print(currentLocation) }
    }
    lazy private var categoryVC = CategoryViewController()
    lazy private var searchVC = CurrentPositionViewController(currentLocation)
    var navVC: UINavigationController?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC()
    }
    
    
    private func addChildVC() {
        addChild(categoryVC)
        view.addSubview(categoryVC.view)
        didMove(toParent: self)
        
        searchVC.delegate = self
        categoryVC.delegate = searchVC
        let navVC = UINavigationController(rootViewController: searchVC)
        navVC.navigationItem.titleView?.isOpaque = true
        
        addChild(navVC)
        view.addSubview(navVC.view)
        didMove(toParent: self)
        
        self.navVC = navVC
    }
    
    func toogleMenu(completion: (() -> Void)?) {
         print("tap")
              UIView.animate(withDuration: 0.5,
                             delay: 0.1,
                             usingSpringWithDamping: 0.8,
                             initialSpringVelocity: 0.2,
                             options: .curveEaseIn) {
                  self.navVC?.view.frame.origin.x = ( self.categoryState ? 0 : 300)
              } completion: { [weak self] done in
                  self?.categoryState.toggle()
          }
    }
}

extension MainViewController: CurrentPositionControllerDelegate {
    func didSlideCategoryMenu() {
        toogleMenu {
            print("menu togle")
        }
    }
}
