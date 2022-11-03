//
//  CategoryViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 10.09.2022.
//

import UIKit
import SnapKit

protocol CategoryViewControllerDelegate: AnyObject {
    
    func searchPlaces(_ from: AnyObject ,by category: String, titletext: String)
    
}

class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
 
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
        return Categories.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = Categories.allCases[indexPath.row]
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
        let ind = String(Categories.allCases[indexPath.row].searchIndex)
        let titleText = Categories.allCases[indexPath.row].titleText
        self.delegate?.searchPlaces(self, by: ind, titletext: titleText)
    }
}

