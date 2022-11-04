//
//  FavoriteTBLCell.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import UIKit

class FavoriteTBLCell: UITableViewCell {
    static let id = "FavoriteTBLCell"
    static func nib() -> UINib {
        return UINib(nibName: Self.id, bundle: nil)
    }
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setupCell(by city: PlaceProtocol) {
        self.countryNameLabel.text = city.country ?? "UI"
        self.cityNameLabel.text = city.name
        self.stateLabel.text = "region: \(city.state ?? "has not found")"
    }
    
}
