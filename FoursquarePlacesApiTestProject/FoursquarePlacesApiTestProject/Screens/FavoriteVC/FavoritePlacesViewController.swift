//
//  FavoritePlacesViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 03.11.2022.
//

import UIKit
import Moya

class FavoritePlacesViewController: UIViewController {
    let moya = NetworkProvider()
    var datasource: [PlaceProtocol] = [] {
        didSet {
            print(datasource)
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        datasource = FavoriteCity.getTestdata()
    }
    
    @IBAction func searchPlacesButtonPressed(_ sender: Any) {
        self.searchNewCityAlert { [weak self] term in
            self?.searchCity(by: term)
        }
    
    }
    
    fileprivate func setupVC() {
        view.backgroundColor = .green
        tableView.register(FavoriteTBLCell.nib(),
                           forCellReuseIdentifier: FavoriteTBLCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func searchCity(by term: String) {
        moya.openweather.request(.getCities(term: term, limit: 10)) {[weak self] result in
            switch result {
            case .success(let responce):
               // print(String(bytes: responce.data, encoding: .utf8))
            guard let cityes = self?.moya.decodejson(type: [CityModel].self,
                    from: responce.data) else {
                        print("data has not been decoded")
                        return
                    }
                    self?.datasource = cityes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension FavoritePlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.row]
       guard let cell = tableView.dequeueReusableCell(
        withIdentifier: FavoriteTBLCell.id,
        for: indexPath) as? FavoriteTBLCell else {
           return UITableViewCell()
       }
        cell.setupCell(by: model)
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension FavoritePlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if datasource.isEmpty {
            return "You have not any favorite places"
        } else {
            return nil
        }
    }
}
