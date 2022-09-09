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
       // backgroundColor = .clear
        layer.cornerRadius = 8
    }
    
    public func setupCell(photo: PhotoItem, width: Int? , height: Int?) {
        
        dateLabel.text = photo.dateStr()
        let w = width ?? ( photo.width ?? 600)
        let h = height ?? ( photo.height ?? 600 )
        let url = photo.photoUrlStr(w: w, h: h)
        photoImageView.sd_setImage(with: url)
    }
    

}
