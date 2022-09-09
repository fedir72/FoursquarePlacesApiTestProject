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
    static let itemInRow: CGFloat = 3
    static let minimumSpacing: CGFloat = 1
}

class PhotoViewController: UIViewController {
    
    
    private var isShowDetail = false {
        didSet {
                self.collection.reloadData()
        }
    }
    
    
    static let id = "PhotoViewController"
    private let fsqProvider = FoursquareProvider()
    var fsqId = ""
    
  private var dataSourse = [PhotoItem]() {
        didSet { self.collection.reloadData() }
    }
 
  private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.minimumSpacing
        layout.minimumInteritemSpacing = Constant.minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 1)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PhotoCVCell.nib, forCellWithReuseIdentifier: PhotoCVCell.id)
        return collection
    }()
  
    //MARK: - life cycle
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        
        self.fsqProvider.moya.request(.placePhotos(id: self.fsqId)) { result in
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
                                          """)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSourse[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVCell.id,
                                                           for: indexPath) as? PhotoCVCell else {
             return UICollectionViewCell()
        }
        cell.setupCell(photo: item, width: 300, height: 300)
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPhotoViewController(with: dataSourse, selected: indexPath)
        present(vc, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.size.width
        let calculatedWidth = (width - (Constant.minimumSpacing*(Constant.itemInRow+1)))/Constant.itemInRow
        let cellWidth = isShowDetail ? width : calculatedWidth
        return .init(width: cellWidth, height: cellWidth)
    }
    
}

private extension PhotoViewController {
    
    func setupCollectionView() {
        collection.delegate = self
        collection.dataSource = self
    }
    
    func setupUI() {
    navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .edit,
                        target: self,
                        action: #selector(showdetailCollection))
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func showdetailCollection() {
        self.isShowDetail.toggle()
        print("toggle")
    }
}
