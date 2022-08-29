//
//  PhotoViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit
import SnapKit

private struct Constant {
    static let itemInRow: CGFloat = 2
    static let minimumSpacing: CGFloat = 1
}

class PhotoViewController: UIViewController {
    static let id = "PhotoViewController"
    
    var dataSourse = [PhotoItem]() {
        didSet { self.collection.reloadData() }
    }
    
  fileprivate lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.minimumSpacing
        layout.minimumInteritemSpacing = Constant.minimumSpacing
      layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 1)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PhotoCVCell.nib, forCellWithReuseIdentifier: PhotoCVCell.id)
        return collection
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        cell.setupCell(photo: item)
        return cell
        
    }
    
    
}

extension PhotoViewController: UICollectionViewDelegate {
    
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.size.width
        let cellWidth = (width - (Constant.minimumSpacing*(Constant.itemInRow+1)))/Constant.itemInRow
        return .init(width: cellWidth, height: cellWidth)
    }
    
    
}

private extension PhotoViewController {
    func setupCollectionView() {
        collection.delegate = self
        collection.dataSource = self
    }
}
