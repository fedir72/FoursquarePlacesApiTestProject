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
    
    var photoUrl: URL?
    var imageScrollView: ImageScrollView!
    
    init(photoUrl: URL) {
        self.photoUrl = photoUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(photoUrl)
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
                imageScrollView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
        let imagePath = Bundle.main.path(forResource: "autumn", ofType: "jpeg")!
        let img = UIImage(contentsOfFile: imagePath)!

        imageScrollView.set(image: img)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  imageScrollView.setImage(by: photoUrl)
    }
 
   
   @objc private func returnToPreviousVC() {
        dismiss(animated: true)
    }
    

}
