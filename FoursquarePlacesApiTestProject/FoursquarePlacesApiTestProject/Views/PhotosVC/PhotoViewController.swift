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
    static var itemInRow: CGFloat = 2
    static let minimumSpacing: CGFloat = 1
}

class PhotoViewController: UIViewController {

    static let id = "PhotoViewController"
    private var itemInRow: CGFloat = 2 {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0.0) {
                self.collection.reloadData()
                self.collection.scrollsToTop = true
            }
        }
    }
    private let fsqProvider = FoursquareProvider()
    var fsqId = ""
    private var dataSourse = [PhotoItem]() {
        didSet {
            self.collection.reloadData()
        }
    }
 
  //MARK: - UI objects
  private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constant.minimumSpacing
        layout.minimumInteritemSpacing = Constant.minimumSpacing
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 1)
      
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.alwaysBounceVertical = true
        collection.layer.cornerRadius =  8
        collection.register(PhotoCVCell.nib, forCellWithReuseIdentifier: PhotoCVCell.id)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBarButton()
        
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
                                          """) { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension PhotoViewController: UICollectionViewDataSource {
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

extension PhotoViewController: UICollectionViewDelegate {
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

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collection.bounds.size.width
        let cellWidth = (width - (Constant.minimumSpacing*(itemInRow+1)))/itemInRow
        return .init(width: cellWidth, height: cellWidth)
    }
}

//MARK: - private methods
private extension PhotoViewController {
    func setupUI() {
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
 
    func setupBarButton() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "eyeglasses"),
            primaryAction: nil,
            menu: self.menu()
            )
    }
    
    func menu() -> UIMenu {
        let menu = UIMenu(
            title: "choise the size of photos",
            options: [.displayInline],
            children: [
                        UIAction(title: "small (X4)") { _ in
                            self.itemInRow = 4
                        },
                        UIAction(title: "medium (X3)") { _ in
                            self.itemInRow = 3
                        },
                        UIAction(title: "large (X2)") { _ in
                            self.itemInRow = 2
                        },
                        UIAction(title: "X.large (X1)") { _ in
                            self.itemInRow = 1
                        }
                      ])
        
        return menu
    }
}
