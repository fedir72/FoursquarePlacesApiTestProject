//
//  MainTBCell.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit
import SDWebImage

class MainTBCell: UITableViewCell {
    
    static let id = "MainTBCell"
    static func nib() -> UINib {
        return UINib(nibName: Self.id,
                     bundle: nil)
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 8
        iconImageView.backgroundColor = UIColor(named: "MyTint")
        iconImageView.tintColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func setupCell(with place: Place) {
        nameLabel.text = place.name
       let url = place.categories.first?.icon.iconURl(resolution: .small)
       iconImageView.sd_setImage(with: url,
                                 placeholderImage: UIImage(systemName: "questionmark") )
    }
}
