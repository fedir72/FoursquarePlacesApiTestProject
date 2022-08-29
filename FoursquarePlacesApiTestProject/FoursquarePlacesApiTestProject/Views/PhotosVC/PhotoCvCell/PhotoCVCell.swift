//
//  PhotoCVCell.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit
import SDWebImage

class PhotoCVCell: UICollectionViewCell {
    static let id = "PhotoCVCell"
    static var nib: UINib {
        return UINib(nibName:  "PhotoCVCell",
                     bundle: nil)
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }
    
    public func setupCell(photo: PhotoItem) {
      lazy var plaseholder = UIImage(systemName: "photo.fill")
        dateLabel.text = photo.dateStr()
        let url = photo.photoUrlStr(w: 300, h: 300)
        photoImageView.sd_setImage(with: url,
                                   placeholderImage: plaseholder)
    }
    

}
