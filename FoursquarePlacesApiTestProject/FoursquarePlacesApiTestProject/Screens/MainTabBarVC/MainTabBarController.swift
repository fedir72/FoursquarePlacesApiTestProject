//
//  MinTabBarController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 09.11.2022.
//

import UIKit
import CoreLocation

class MainTabBarController: UITabBarController {
    
    private var location: CLLocation = CLLocation() {
        didSet {  setupControllers() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupControllers()
        UserLocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            self.location = location
        }
    }
}

private extension MainTabBarController {
    
    func createController(addNavVC: Bool ,
                          controller: UIViewController,
                          tabBarText: String,
                          tabBarimage: String) -> UIViewController {
        switch addNavVC {
        case false:
            controller.tabBarItem.title = tabBarText
            controller.tabBarItem.image = UIImage(systemName: tabBarimage)
            return controller
        case true:
            let nvc = UINavigationController(rootViewController: controller)
            nvc.view.backgroundColor = .white
            nvc.tabBarItem.title = tabBarText
            nvc.tabBarItem.image = UIImage(systemName: tabBarimage)
            return nvc
        }
    }
    
    func setupControllers() {
        let vc = MainViewController()
        vc.currentLocation = location
        let mainVC = createController(addNavVC: false,
                                      controller: vc,
                                      tabBarText: "Places",
                                      tabBarimage: "magnifyingglass")
        let favoriteVC = createController(addNavVC: true,
                                          controller: FavoritePlaceViewController(),
                                          tabBarText: "Favorites",
                                          tabBarimage: "star.fill")
        self.viewControllers = [mainVC,favoriteVC]
        self.tabBar.backgroundColor = .systemBackground
    }

}
