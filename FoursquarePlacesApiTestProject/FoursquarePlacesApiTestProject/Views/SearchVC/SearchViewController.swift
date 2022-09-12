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

    var isShowedSearchbar = false {
        didSet { slideTableview() }
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
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar(frame: .null)
        search.layer.opacity = 0.2
        search.layer.cornerRadius = 13
        search.placeholder = "enter search term"
        search.clipsToBounds = true
        return search
    }()
 
    private lazy var placesTableView: UITableView = {
        let table = UITableView()
        table.register(MainTBCell.nib(), forCellReuseIdentifier: MainTBCell.id)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()
         setupVC()
         UserLocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            self.userLocation = location
            }
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

extension SearchViewController: UISearchBarDelegate {
    
}


private extension SearchViewController {
    
    @objc  func showSettings() {
        placesTableView.isUserInteractionEnabled.toggle()
        //placesTableView.alpha = 0.1
        delegate?.didSlideCategoryMenu()
    }
    
    @objc  func showSearchBar() {
        isShowedSearchbar.toggle()
    }
    
    func slideTableview() {
        
        placesTableView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(self.isShowedSearchbar ? 200 : 0 )
            $0.left.right.equalToSuperview().inset(self.isShowedSearchbar ? 10 : 0)
            $0.bottom.equalToSuperview().inset(self.isShowedSearchbar ? 60 : 0)
        }
        searchBar.snp.updateConstraints {
            $0.top.equalToSuperview().inset(self.isShowedSearchbar ? 140 : 60 )
            $0.left.right.equalToSuperview().inset(self.isShowedSearchbar ? 10 : 60)
        }
        
        
        UIView.animate(withDuration: 0.3,
                        delay: 0.05,
                        usingSpringWithDamping: 0.7,
                        initialSpringVelocity: 0.3) {
            self.searchBar.layer.opacity = (self.isShowedSearchbar ? 1 : 0.2)
            
            self.placesTableView.layer.cornerRadius = (self.isShowedSearchbar ? 20 : 0)
            self.placesTableView.isUserInteractionEnabled.toggle()
            self.placesTableView.layer.opacity = (self.isShowedSearchbar ? 0.2 : 1)
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    func setupUI() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.left.right.equalToSuperview().inset(60)
            $0.height.equalTo(50)
        }
        view.addSubview(placesTableView)
        placesTableView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setupVC() {
        
        view.backgroundColor = UIColor(named: "MyTint")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(
            systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(showSettings))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(
            systemName: "magnifyingglass.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(showSearchBar))
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
