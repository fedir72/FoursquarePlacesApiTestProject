//
//  ViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import UIKit
import Moya
import CoreLocation

class MainViewController: UIViewController {
    
    let fsqProvider = MoyaProvider<FoursquareService>()
    var datasourse = [Place]() {
        didSet { tableview.reloadData() }
    }
    
    var userLocation = CLLocation() {
        didSet {
        print(self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude )
            self.fsqProvider.request(.getPlaces(term: "hotel",
                                                lat: self.userLocation.coordinate.latitude,
                                                long:self.userLocation.coordinate.longitude,
                                                radius: 1000,
                                                limit: 50)) { result in
                switch result {
                    
                case .success(let responce):
                   // print("Data",String(data: responce.data, encoding: .utf8))
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
    
    @IBOutlet weak var tableview: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Nearest"
        UserLocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            self.userLocation = location
            print("did")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = datasourse[indexPath.row]
        self.cellDidTap(id: item.fsq_id, title: item.name )
    }
    
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
    
    func cellDidTap(id: String,title: String ) {
        let alert = UIAlertController(title: "Atencion", message: "Please make choise", preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .destructive))
        alert.addAction(.init(title: "Show photos", style: .default) { _ in
            
            self.fsqProvider.request(.placePhotos(id: id)) { result in
                switch result {
                case .success(let responce):
                   // print("Data", String(data: responce.data, encoding: .utf8))
                    if let items = self.decodejson(type: Photos.self, from: responce.data),
                       items.count > 0
                    {
                        print(items.count)
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: PhotoViewController.id) as? PhotoViewController {
                            vc.dataSourse = items
                            vc.title = title
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        self.someWrongAlert("Sorry",
                                            "but for this place we can not present you any photos, you could be first")
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        })
        alert.addAction(.init(title: "Show tips", style: .default) { _ in
            self.fsqProvider.request(.placeTips(id: id)) { result in
                switch result {
                case .success(let responce):
                    if let items = self.decodejson(type: Tips.self, from: responce.data) {
                        print(items.count)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        })
        present(alert, animated: true)
    }
    
    
}
