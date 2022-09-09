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
    static let itemInRow: CGFloat = 2
    static let minimumSpacing: CGFloat = 1
}

class PhotoViewController: UIViewController {
    
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
    
    var isBlurred = false
    private lazy var blurView:UIVisualEffectView = {
        let view = UIVisualEffectView(effect: nil)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.addGestureRecognizer(tap)
        imageView.alpha = 0
        return imageView
    }()
    
    
    private lazy var tap: UITapGestureRecognizer = {
        let tapgesture = UITapGestureRecognizer(target:self, action: #selector(hideDetailView))
        tapgesture.numberOfTouchesRequired = 1
        tapgesture.numberOfTapsRequired = 1
        return tapgesture
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailImageView.center = view.center
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSourse[indexPath.item]
        navigationController?.navigationBar.isHidden = true
        blurView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.blurView.effect = !self.isBlurred ? UIBlurEffect(style: .systemUltraThinMaterial) : nil
        }completion: { done in
            self.isBlurred.toggle()
            self.showDetailView(with: item)
        }
 
    }
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
    
    func setupUI() {
        view.addSubview(collection)
        view.addSubview(blurView)
        view.addSubview(detailImageView)
        
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        detailImageView.frame = .init(x: 0, y: 0, width: 10, height: 10)
        detailImageView.center = view.center
    }
  
    @objc private func hideDetailView() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.detailImageView.alpha = 0
            self.detailImageView.frame = .init(x: 0, y: 0, width: 10, height: 10)
            self.detailImageView.center = self.view.center
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0) {
                self.isBlurred.toggle()
                self.blurView.effect = nil
                self.blurView.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.isHidden = false
           }
        }
    }
    
    func showDetailView(with item: PhotoItem ) {
        let photoUrl = item.photoUrlStr(w: item.width ?? 600, h: item.height ?? 600)
        detailImageView.sd_setImage(with: photoUrl) { _,_,_,_  in
            UIView.animate(withDuration: 0.3, delay: 0.1) {
                self.detailImageView.alpha = 1.0
                self.detailImageView.frame = self.view.bounds
            }
        }
    }
}
