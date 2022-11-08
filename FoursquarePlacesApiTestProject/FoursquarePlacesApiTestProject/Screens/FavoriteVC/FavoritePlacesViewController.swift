//
//  FavoritePlacesViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 03.11.2022.
//

import UIKit
import Moya
import SnapKit
import RealmSwift

class FavoritePlacesViewController: UIViewController {
    
    private let realm = try! Realm()
    private let moya = NetworkProvider()
    private var datasource: Results<FavoriteCity>?
    private var itemsToken: NotificationToken?
    private var isTablevieEditable = true {
        didSet {
            cleanDatasourceButton.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(isTablevieEditable ? -20 : -90)
            }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutSubviews()
            }
        }
    }
    var searchDataSorce: [OpenMapCity] = [] {
        didSet {
            switch searchDataSorce.isEmpty {
            case true: return
            case false: self.showSearchResult(searchDataSorce)
            }
        }
    }
    
//MARK: - @IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cleanDatasourceButton: UIButton!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = realm.objects(FavoriteCity.self)
        setupTAbleView()
       // setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsToken = datasource?.observe { [weak tableView] changes in
            guard let tableView = tableView else { return }
          switch changes {
          case .initial:
            tableView.reloadData()
          case .update(_, let deletions, let insertions, let updates):
            tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
          case .error: break
          }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
    }
    
//MARK: - @IBActions
    @IBAction private func searchPlacesButtonPressed(_ sender: Any) {
        if isTablevieEditable {
            self.searchNewCityAlert { [weak self] term in
                self?.searchCity(by: term)
            }
        }
    }
    @IBAction private func refreshButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.isTablevieEditable.toggle()
            self.tableView.isEditing.toggle()
        }
    }
    @IBAction private func cleanDatasourceDidTap(_ sender: Any) {
        print("clean datasourse")
            }
  
}

//MARK: - private functions
private extension FavoritePlacesViewController {
    
    func setupTAbleView() {
        tableView.register(FavoriteTBLCell.nib(),
                           forCellReuseIdentifier: FavoriteTBLCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showSearchResult(_ result: [OpenMapCity]) {
        let alert = UIAlertController(title: "Choise needed geoposition from list",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        result.forEach { place in
            let action = UIAlertAction(title: "\(place.name) - \(place.country ?? "")",
                                       style: .default) { [weak self] _ in
                try! self?.realm.write {
                    self?.realm.add(FavoriteCity.createFavoriteCity(by: place))
                }
            }
            alert.addAction(action)
        }
        alert.addAction(.init(title: "cancel", style: .cancel))
        present(alert, animated: true)
    }
   
    func searchCity(by term: String) {
        moya.openweather.request(.getCities(term: term, limit: 10)) {[weak self] result in
            switch result {
            case .success(let responce):
                // print(String(bytes: responce.data, encoding: .utf8))
                guard let cityes = self?.moya.decodejson(type: [OpenMapCity].self,
                                                         from: responce.data) else {
                    print("data has not been decoded")
                    return
                }
                if cityes.isEmpty {
                    self?.someWrongAlert("atension !!!",
                                         "Nothing is found by your request, try more correct term",
                                         completion: nil)
                } else {
                    self?.searchDataSorce = cityes
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension FavoritePlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource![indexPath.row]
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
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if datasource != nil,
           datasource?.isEmpty == true {
            return "You have not any favorite places"
        } else {
            return "Where you wanna go"
        }
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let item = datasource?[indexPath.row] else { return }
        if editingStyle == .delete {
         try!   realm.write {
             realm.delete(item)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


