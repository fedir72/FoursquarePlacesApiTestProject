//
//  DetailPhotoViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 30.08.2022.
//

import UIKit
import SnapKit
import SDWebImage

class DetailPhotoViewController: UIViewController {
    
    var photo: PhotoItem
    var h: Int
    var w: Int

    private lazy var detailImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()
    
    private lazy var spiner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var tap: UITapGestureRecognizer = {
        let tapgesture = UITapGestureRecognizer(target:self,
                                                action: #selector(returnToPreviousVC))
        tapgesture.numberOfTouchesRequired = 1
        tapgesture.numberOfTapsRequired = 1
        return tapgesture
    }()
    
    
    
    init(photo: PhotoItem) {
        self.photo = photo
        self.h = photo.width ?? 600
        self.w = photo.height ?? 600
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        view.addGestureRecognizer(tap)
        view.backgroundColor = .clear
        view.addSubview(spiner)
        view.addSubview(detailImageView)
        setupPhoto()
    }
    
    private func setupPhoto() {
        let url = photo.photoUrlStr(w: w, h: h)
        spiner.snp.makeConstraints {
            $0.center.equalToSuperview()
           // $0.height.width.equalTo(70)
        }
        detailImageView.sd_setImage(with: url) { _,_,_,_  in
            self.spiner.stopAnimating()
            self.spiner.removeFromSuperview()
        }
        detailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
   @objc private func returnToPreviousVC() {
        dismiss(animated: true)
    }
    

}
