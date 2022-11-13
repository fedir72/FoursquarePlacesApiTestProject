//
//  MainTBCell.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 29.08.2022.
//

import UIKit
import SDWebImage

class SearchTBCell: UITableViewCell {
    
    static let id = "SearchTBCell"
    static func nib() -> UINib {
        return UINib(nibName: Self.id,bundle: nil)
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryNameLAbel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .secondarySystemBackground
        iconImageView.layer.cornerRadius = 8
        iconImageView.backgroundColor = UIColor(named: "MyColor")
        iconImageView.tintColor = .white
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func setupCell(with place: Place) {
        nameLabel.text = place.name
        categoryNameLAbel.text = place.categories?.first?.name ?? "not found"
       let url = place.categories?.first?.icon.iconURl(resolution: .small)
       iconImageView.sd_setImage(with: url,
                                 placeholderImage: UIImage(systemName: "questionmark") )
    }
}
