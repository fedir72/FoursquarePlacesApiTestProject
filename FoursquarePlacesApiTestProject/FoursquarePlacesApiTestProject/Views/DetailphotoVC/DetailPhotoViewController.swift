//
//  DetailPhotoViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 30.08.2022.
//

import UIKit
import SDWebImage

private struct Constant {
    static let itemInRow: CGFloat = 1
    static let minimumSpacing: CGFloat = 0
    static let direction: UICollectionView.ScrollDirection = .horizontal
}

class DetailPhotoViewController: UIViewController {
    
    private var effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private var dataSourse: Photos
    private var selectedIndexPath: IndexPath
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = Constant.direction
        layout.minimumLineSpacing = Constant.minimumSpacing
        layout.minimumInteritemSpacing = Constant.minimumSpacing
        layout.itemSize = CGSize(width: view.bounds.size.width,
                                 height: view.bounds.size.height)
        layout.sectionInset = UIEdgeInsets(top: 1,
                                           left:1,
                                           bottom: 1,
                                           right: 1)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.register(PhotoCVCell.nib, forCellWithReuseIdentifier: PhotoCVCell.id)
        return collection
    }()

    private lazy var tap: UITapGestureRecognizer = {
        let tapgesture = UITapGestureRecognizer(target:self,
                                                action: #selector(returnToPreviousVC))
        tapgesture.numberOfTouchesRequired = 1
        tapgesture.numberOfTapsRequired = 2
        return tapgesture
    }()
    
    
    
    init(with datasourse: Photos,selected indexPath: IndexPath) {
        self.dataSourse = datasourse
        self.selectedIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collection.isPagingEnabled = false
       // self.collection.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
        self.collection.selectItem(at: self.selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        self.collection.isPagingEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
}

extension DetailPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSourse[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVCell.id,
                                                           for: indexPath) as? PhotoCVCell else {
             return UICollectionViewCell()
        }
        cell.setupCell(photo: item, width: nil, height: nil)
        return cell
    }
}

extension DetailPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}





private extension DetailPhotoViewController {
   
    func setupUI() {
        view.addSubview(effectView)
        effectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        collection.delegate = self
        collection.dataSource = self
        collection.scrollToItem(at: self.selectedIndexPath, at: .top, animated: true)
        view.backgroundColor = .clear
        view.addGestureRecognizer(tap)
        view.addSubview(collection)
    }
    
    func setupConstraints() {
        collection.frame = view.bounds
    }
    
   @objc func returnToPreviousVC() {
       dismiss(animated: true)
    }

}
