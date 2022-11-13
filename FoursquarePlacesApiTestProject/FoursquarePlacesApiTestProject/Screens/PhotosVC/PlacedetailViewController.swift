//
//  PhotoViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit
import SnapKit
import Moya
import SDWebImage

private struct Constant {
    static let minimumSpacing: CGFloat = 3
    static let numberOfcellsInRow = "numberOfcellsInRow"
}

class PlacedetailViewController: UIViewController {
    
    enum CellSize {
        case small
        case medium
        case large
        case xlarge
    }
    
    let moya = NetworkProvider()
    static let id = "PhotoViewController"
    let userdefault = UserDefaults.standard
    private let fsqProvider = NetworkProvider()
    var fsqId = ""
    
    
//    var isShowedTipsTableview = false {
//        didSet {
//            switch isShowedTipsTableview {
//            case true: self.showTipsTableView()
//            case false: self.closeTipsTableView()
//            }
//        }
//    }
    //MARK: - handle collectionview
    private lazy var cellSize: CellSize = self.getDataFromUserdefauils() {
        didSet { setupItemInRow() }
    }
    
    private lazy var itemInRow: CGFloat = 3 {
        didSet {
            userdefault.set(Int(itemInRow), forKey: Constant.numberOfcellsInRow)
            self.collection.reloadData()
        }
    }
    
    //MARK: - datasources
    private var dataSourse = [PhotoItem]() {
        didSet {
            self.collection.reloadData()
        }
    }
    private var tipsDataSource: Tips = [] {
        didSet {
            if tipsDataSource.isEmpty {
                closeTipsTableView()
            } else {
                //print(tipsDataSource)
                showTipsTableView()
                //tipsTable?.reloadData()
            }
        }
    }
    
    //MARK: - UI objects
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.minimumSpacing
        layout.minimumInteritemSpacing = Constant.minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: Constant.minimumSpacing,
                                           bottom: Constant.minimumSpacing,
                                           right: Constant.minimumSpacing)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.alwaysBounceVertical = true
        collection.layer.cornerRadius =  8
        collection.register(PhotoCVCell.nib, forCellWithReuseIdentifier: PhotoCVCell.id)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private var tipsTable: UITableView?
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBarButton()
        
        self.fsqProvider.foursquare.request(.placePhotos(id: self.fsqId)) { result in
            switch result {
            case .success(let responce):
                // print("Data", String(data: responce.data, encoding: .utf8))
                if let items = self.fsqProvider.decodejson(type: Photos.self, from: responce.data),
                   items.count > 0 {
                    self.dataSourse = items
                } else {
                    self.someWrongAlert("Sorry",
                                          """
                                          but for this place we
                                          can not present you any photos,
                                          you could be first
                                          """) { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupItemInRow()
    }
    
    func setupItemInRow() {
        if view.bounds.width < view.bounds.height {
            switch cellSize {
            case .small: itemInRow = 4
            case .medium: itemInRow = 3
            case .large: itemInRow = 2
            case .xlarge: itemInRow = 1
            }
        } else {
            switch cellSize {
            case .small: itemInRow = 8
            case .medium: itemInRow = 6
            case .large: itemInRow = 4
            case .xlarge: itemInRow = 2
            }
        }
    }
    
    func getDataFromUserdefauils() -> CellSize {
    let number = userdefault.integer(forKey: Constant.numberOfcellsInRow)
        switch number {
        case 1: return .xlarge
        case 2: return .large
        case 3: return .medium
        default: return .small
        }
    }
 
}


extension PlacedetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
          numberOfItemsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
                        -> UICollectionViewCell {
        let item = dataSourse[indexPath.item]
      guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCVCell.id,
            for: indexPath) as? PhotoCVCell else {
          return UICollectionViewCell()
        }
        cell.setupCell(photo: item)
        return cell
    }
}

extension PlacedetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSourse[indexPath.item]
        guard let w = item.width,
              let h = item.height,
              let url = item.photoUrlStr(w: w, h: h) else { return }
        let imgv = UIImageView()
        imgv.sd_setImage(with: url) {_,_,_,_ in
            guard let image = imgv.image else {return}
            //MARK: - show detail photo
            let vc = DetailPhotoViewController(image: image)
            self.present(vc, animated: true)
        }
    }
}

extension PlacedetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collection.bounds.size.width
        let cellWidth = (width - (Constant.minimumSpacing*(itemInRow+1)))/itemInRow
        return .init(width: cellWidth, height: cellWidth)
    }
}

//MARK: - private methods
private extension PlacedetailViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
 
    func setupBarButton() {
        navigationItem.rightBarButtonItems = [
        UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "eyeglasses"),
            primaryAction: nil,
            menu: self.menu()),
        UIBarButtonItem(title: "Tips",
                        style: .plain,
                        target: self,
                        action: #selector(showTips))
        ]
    }
    
    func setupTipsTable() {
        self.tipsTable = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tipsTable!)
        guard let tipsTable else { return }
        //tipsTable.estimatedRowHeight = 100
        tipsTable.register(TipsTableViewCell.nib,
                            forCellReuseIdentifier: TipsTableViewCell.id)
        tipsTable.layer.cornerRadius = 20
        tipsTable.layer.opacity = 0.01
        //tipsTable?.rowHeight = 40
        tipsTable.dataSource = self
        tipsTable.delegate = self
        tipsTable.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    func deleletable() {
        collection.isUserInteractionEnabled = true
        tipsTable?.removeFromSuperview()
        tipsTable = nil
    }
    
    @objc func showTips() {
        if tipsDataSource.isEmpty {
            getTips(by: fsqId)
        } else {
            tipsDataSource = []
        }
    }
    
    func showTipsTableView() {
        self.setupTipsTable()
        self.collection.isUserInteractionEnabled = (self.tipsDataSource.isEmpty ? true : false)
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.3){
            self.collection.layer.opacity = (self.tipsDataSource.isEmpty ? 1.0 : 0.2)
        }
        UIView.animate(withDuration: 0.3,
                       delay: 0.3){
            self.tipsTable?.layer.opacity = 1.0
        }
    }
    
    func closeTipsTableView() {
        self.tipsTable?.isUserInteractionEnabled = false
        self.collection.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0.05,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.3){
            self.tipsTable?.layer.opacity = 0.01
        } completion: { _ in
            self.deleletable()
        }
        UIView.animate(withDuration: 0.3,
                       delay: 0.3,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.3){
            self.collection.layer.opacity = 1.0
        }
    }
    
    func menu() -> UIMenu {
        let menu = UIMenu(
            title: "choise the size of photos",
            options: [.displayInline],
            children: [
                        UIAction(title: "small (X4)") { _ in
                            self.cellSize = .small
                        },
                        UIAction(title: "medium (X3)") { _ in
                            self.cellSize = .medium
                        },
                        UIAction(title: "large (X2)") { _ in
                            self.cellSize = .large
                        },
                        UIAction(title: "X.large (X1)") { _ in
                            self.cellSize = .xlarge
                        }
                      ])
        
        return menu
    }
    
    func getTips(by placeId: String) {
        moya.foursquare.request(.placeTips(id: placeId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let responce):
                guard let newSource = self.moya.decodejson(type: Tips.self, from: responce.data)
                else {
                    return
                }
                switch newSource.isEmpty {
                case true:
                    self.someWrongAlert("We sorry",
                                   "but these place do not have any  user tips",
                                   completion: nil)
                case false:
                    self.tipsDataSource = newSource
                }
                
            case .failure(let error):
                self.someWrongAlert("Attencion",
                                    error.localizedDescription,
                                    completion: nil)
            }
        }
    }
}

extension PlacedetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsDataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tipsTable?.dequeueReusableCell(
            withIdentifier: TipsTableViewCell.id,
            for: indexPath) as? TipsTableViewCell {
           let tip = tipsDataSource[indexPath.row]
           cell.setupCell(by: tip)
           return cell
       } else {
           return UITableViewCell()
       }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Customers tips"
    }
    
}

extension PlacedetailViewController: UITableViewDelegate {
   
}

