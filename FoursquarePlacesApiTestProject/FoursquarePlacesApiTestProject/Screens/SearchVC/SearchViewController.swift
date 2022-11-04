//// A delay function
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
    let fsqProvider = NetworkProvider()
    
    var isShowedSearchbar = false {
        didSet { slideTableview() }
    }
    var datasourse = [Place]() {
        didSet { placesTableView.reloadData() }
    }
    var userLocation = CLLocation() {
        didSet {
        //print(self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude )
            self.getDataForDatasource(term: nil, category: nil)
      }
    }
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar(frame: .null)
        search.delegate = self
        search.layer.opacity = 0
        search.layer.cornerRadius = 13
        search.placeholder = "enter search term"
        search.clipsToBounds = true
        return search
    }()
 
    private lazy var placesTableView: UITableView = {
        let table = UITableView()
        table.register(SearchTBCell.nib(), forCellReuseIdentifier: SearchTBCell.id)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTBCell.id, for: indexPath) as? SearchTBCell else {
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
    
    @objc  func showSettings() {
        placesTableView.isUserInteractionEnabled.toggle()
        delegate?.didSlideCategoryMenu()
    }
    
    @objc  func showSearchBar() {
        navigationItem.leftBarButtonItem?.isEnabled.toggle()
        isShowedSearchbar.toggle()
    }
    
    func slideTableview() {
        placesTableView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(self.isShowedSearchbar ? 200 : 150 )
            $0.left.right.equalToSuperview().inset(self.isShowedSearchbar ? 10 : 0)
            $0.bottom.equalToSuperview().inset(self.isShowedSearchbar ? 60 : 0)
        }
        searchBar.snp.updateConstraints {
            $0.top.equalToSuperview().inset(self.isShowedSearchbar ? 140 : 20 )
            $0.left.right.equalToSuperview().inset(self.isShowedSearchbar ? 10 : 60)
        }
        UIView.animate(withDuration: 0.3,
                        delay: 0.05,
                        usingSpringWithDamping: 0.7,
                        initialSpringVelocity: 0.3) {
            self.searchBar.layer.opacity = (self.isShowedSearchbar ? 1 : 0)
            self.placesTableView.layer.cornerRadius = (self.isShowedSearchbar ? 13 : 0)
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
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
    }
    
    func setupVC() {
        navigationItem.titleView?.tintColor = .white
        view.backgroundColor = UIColor(named: "MyTint")
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Nearest"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(
            systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(showSettings))
    }
    
    func setupRightBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(
            systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(showSearchBar)),
        UIBarButtonItem(
            image: UIImage(systemName:"globe"),
            style: .plain,
            target: self,
            action: #selector(showMap)) ]
    }
    
    @objc func showMap() {
        let vc = MapViewController(location: self.userLocation,
                                   places: self.datasourse,
                                   termText: self.title ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func cellDidTap(id: String,title: String ) {
        let alert = UIAlertController(title: "Atencion", message: "Please make choise", preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .destructive))
        alert.addAction(.init(title: "Show photos", style: .default) { _ in
              let vc =  PhotoViewController()
                vc.fsqId = id
                vc.title = title
                self.navigationController?.pushViewController(vc, animated: true)
        })
        alert.addAction(.init(title: "Show tips", style: .default) { _ in

            
        })
        present(alert, animated: true)
    }
    
    func getDataForDatasource(term: String?,category index: String? ) {
        self.fsqProvider.foursquare.request(
         .getPlaces(term: term ?? "",
                category: index ?? "",
                lat: self.userLocation.coordinate.latitude,
                long:self.userLocation.coordinate.longitude,
                radius: 1000,
                limit: 50)) { result in
                switch result {
                    case .success(let responce):
                        guard let value = self.fsqProvider.decodejson(type: Places.self, from: responce.data) else {
                            return
                        }
                        self.datasourse = value.results
                        if term == nil, index == nil {
                            delay(seconds: 0.5) {
                                self.someWrongAlert("Now you see all kind of places",
                                            """
                                            if you wanna see more precise result
                                            pleace enter searching term
                                            or choise place category
                                            """) { [weak self] in
                                    self?.setupRightBarButtons()
                                }

                            }
                        }
                    case .failure(let error): print(error.localizedDescription)
            }
        }
    }
}

//MARK: - CategoryViewControllerDelegate
extension SearchViewController: CategoryViewControllerDelegate {
    
    func searchPlaces(_ from: AnyObject, by category: String, titletext: String) {
        print(category)
        self.placesTableView.isUserInteractionEnabled = true
        self.title = titletext
        delegate?.didSlideCategoryMenu()
        self.getDataForDatasource(term: nil, category: category)
    }
    
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let txt = searchBar.text, txt.isEmpty == false  else { return }
        searchBar.text = nil
        isShowedSearchbar.toggle()
        navigationItem.leftBarButtonItem?.isEnabled = true
        self.title = txt.capitalized
        self.getDataForDatasource(term: txt, category: nil)
    }
    
}
