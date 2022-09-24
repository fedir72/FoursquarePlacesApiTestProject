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
    private let blurView: UIVisualEffectView = {
        let blurview = UIVisualEffectView(effect: nil)
        return blurview
    }()

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
        view.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        imageScrollView.set(image: image!)
        imageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageScrollView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showScrollView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    deinit {
        print(#function)
    }
 
    func showScrollView() {
        UIView.animate(withDuration: 0.15, delay: 0.0) {
            self.blurView.effect = UIBlurEffect(style: .regular)
        }
        UIView.animate(withDuration: 0.15, delay: 0.15) {
            self.imageScrollView.alpha = 1.0
        }
    }
    
    @objc private func closeTap() {
      dismiss(animated: true)
    }

}
