//
//  FavoritePlacesViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 03.11.2022.
//

import UIKit

class FavoritePlacesViewController: UIViewController {
    
    var datasource: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    @IBAction func searchPlacesButtonPressed(_ sender: Any) {
    }
    
    fileprivate func setupVC() {
        view.backgroundColor = .green
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

//MARK: - UITableViewDataSource
extension FavoritePlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "row: \(indexPath.row+1)"
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension FavoritePlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if datasource.isEmpty {
            return "You have not any favorite places"
        } else {
            return nil
        }
    }
}
