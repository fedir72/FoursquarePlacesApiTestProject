//
//  SearchViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import UIKit
import Moya
import CoreLocation
import SnapKit


protocol SearchViewControllerDelegate: AnyObject {
    func didSlideCategoryMenu()
}

class SearchViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    let fsqProvider = FoursquareProvider()
    var isSlidedTable = false {
        didSet {
            print(isSlidedTable)
    
        }
    }
    var datasourse = [Place]() {
        didSet { placesTableView.reloadData() }
    }
    
    var userLocation = CLLocation() {
        didSet {
        //print(self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude )
            self.fsqProvider.moya.request(.getPlaces(term: "entertainment",
                                                lat: self.userLocation.coordinate.latitude,
                                                long:self.userLocation.coordinate.longitude,
                                                radius: 1000,
                                                limit: 50)) { result in
                switch result {
                    
                case .success(let responce):
                   // print("Data",String(data: responce.data, encoding: .utf8))
                    guard let value = self.fsqProvider.decodejson(type: Places.self, from: responce.data) else {
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
 
    private lazy var placesTableView: UITableView = {
        let table = UITableView()
        table.register(MainTBCell.nib(), forCellReuseIdentifier: MainTBCell.id)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupTableView()
         setupVC()
         UserLocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            self.userLocation = location
            }
         }
    
    @objc  func showSettings() {
        placesTableView.isUserInteractionEnabled.toggle()
        //placesTableView.alpha = 0.1
        delegate?.didSlideCategoryMenu()
    }  
}

//MARK: - UITableViewDatasource
extension SearchViewController: UITableViewDataSource {
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

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = datasourse[indexPath.row]
        self.cellDidTap(id: item.fsq_id, title: item.name )
 }
}


private extension SearchViewController {
    
    func setupTableView() {
        view.addSubview(placesTableView)
        placesTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(showSettings))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Nearest"
    }
    
    
    func cellDidTap(id: String,title: String ) {
        let alert = UIAlertController(title: "Atencion", message: "Please make choise", preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .destructive))
        alert.addAction(.init(title: "Show photos", style: .default) { _ in
        print("vc")
              let vc =  PhotoViewController()
                vc.fsqId = id
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
            
        })
        alert.addAction(.init(title: "Show tips", style: .default) { _ in

            
        })
        present(alert, animated: true)
    }
 
}
