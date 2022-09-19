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
    
    //var photoUrl: URL?
    private var image: UIImage?
    private var photoUrl: URL?
    var imageScrollView: ImageScrollView!
    
    //MARK: - later: to try hand over url to controller and fetch image here
    init(photoUrl: URL) {
        self.photoUrl = photoUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage) {
        self.image = image
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.set(image: image!)
        imageScrollView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
    }
 
}
