//
//  CategoryViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 10.09.2022.
//

import UIKit
import SnapKit

protocol CategoryViewControllerDelegate: AnyObject {
    
    func searchPlaces(_ from: AnyObject ,by category: String)
    
}

class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
    var categories = [String]()
    
    enum Category: String, CaseIterable {
        
        case artsAndEntertainment
        case businessAndProfessionalServices
        case communityAndGovernment
        case diningAndDrinking
        case event
        case healthAndMedicine
        case landmarksAndOutdoors
        case retail
        case sportsAndRecreation
        case travelAndTransportation
        
        var imageName: String {
            switch self {
            case .artsAndEntertainment: return "theatermasks"
            case .businessAndProfessionalServices: return "dollarsign.square"
            case .communityAndGovernment: return "building.columns.fill"
            case .diningAndDrinking: return "cup.and.saucer.fill"
            case .event: return "person.3"
            case .healthAndMedicine: return "heart.circle.fill"
            case .landmarksAndOutdoors: return "globe.europe.africa"
            case .retail: return "cart.fill"
            case .sportsAndRecreation: return "sportscourt.fill"
            case .travelAndTransportation: return "airplane.circle"
                
            }
        }
        
        var searchIndex: Int {
            switch self {
            case .artsAndEntertainment: return 10000
            case .businessAndProfessionalServices: return 11000
            case .communityAndGovernment: return  12000
            case .diningAndDrinking: return 13000
            case .event: return 14000
            case .healthAndMedicine: return 15000
            case .landmarksAndOutdoors: return 16000
            case .retail: return 17000
            case .sportsAndRecreation: return 18000
            case .travelAndTransportation: return 19000
                
            }
        }
        
        var titleText: String {
            switch self {
                
            case .artsAndEntertainment: return " Arts and entertainment"
            case .businessAndProfessionalServices: return "Businnes and services"
            case .communityAndGovernment: return "community and goverment"
            case .diningAndDrinking: return "Dining and drinking"
            case .event: return "Events"
            case .healthAndMedicine: return "Health end medicine"
            case .landmarksAndOutdoors: return "Landmarks and Outdoors"
            case .retail: return "Retail"
            case .sportsAndRecreation: return "Sport and recreation"
            case .travelAndTransportation: return "Travel and transportation"
            }
        }
        
    }
    
    
    
   private lazy var categorytableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
       table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()

        label.text = "Search category"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.left.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(60)
        }
        view.addSubview(categorytableView)
        categorytableView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(30)
            $0.top.equalTo(categoryLabel.snp.bottom).inset(10)
        }
    }
    

}

//MARK: - UICollectionViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = Category.allCases[indexPath.row]
        let cell = categorytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.titleText
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .light)
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: item.imageName)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
}
//MARK: - UICollectionViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categorytableView.deselectRow(at: indexPath, animated: true)
        //print(indexPath.row)
        let ind = String(Category.allCases[indexPath.row].searchIndex)
        self.delegate?.searchPlaces(self, by: ind)
    }
}

