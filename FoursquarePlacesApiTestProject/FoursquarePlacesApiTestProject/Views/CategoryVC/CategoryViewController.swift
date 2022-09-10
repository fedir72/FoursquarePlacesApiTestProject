//
//  CategoryViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 10.09.2022.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var categories = [String]()
    
    private lazy var categorytableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categorytableView.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .darkGray
        view.addSubview(categorytableView)
    }

  
}

//MARK: - UICollectionViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categorytableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "text \(indexPath.row)"
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.textColor = .systemGray6
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl: UILabel = {
            let lbl = UILabel()
            lbl.font = .systemFont(ofSize: 20, weight: .regular)
            lbl.text = " Search category"
            lbl.textColor = .systemMint
            return lbl
        }()
        return lbl
    }
    
}
//MARK: - UICollectionViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categorytableView.deselectRow(at: indexPath, animated: true)
    }
}

