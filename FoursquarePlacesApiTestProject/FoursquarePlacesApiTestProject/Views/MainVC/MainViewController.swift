//
//  ViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import UIKit
import Moya

class MainViewController: UIViewController {
    
    let fsqProvider = MoyaProvider<FoursquareService>()
    var datasourse = [Place]() {
        didSet { tableview.reloadData() }
    }
    
    @IBOutlet weak var tableview: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Nearest"
        fsqProvider.request(.getPlaces(term: "market",
                                       lat: 51.509865,
                                       long: -0.118092,
                                       radius: 1000,
                                       limit: 50)) { result in
            switch result {
                
            case .success(let responce):
                print("Data",String(data: responce.data, encoding: .utf8))
                guard let value = self.decodejson(type: Places.self, from: responce.data) else {
                    print("do not decoded")
                    return
                }
                self.datasourse = value.results
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = datasourse[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTBCell.id, for: indexPath) as? MainTBCell else {
            return UITableViewCell()
        }
        cell.setupCell(with: place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    
}

private extension MainViewController {
    
    func setupTableView() {
        tableview.register(MainTBCell.nib(), forCellReuseIdentifier: MainTBCell.id)
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    private func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("data has been not decoded : \(error.localizedDescription)")
            return nil
        }
    }
    
    
}
