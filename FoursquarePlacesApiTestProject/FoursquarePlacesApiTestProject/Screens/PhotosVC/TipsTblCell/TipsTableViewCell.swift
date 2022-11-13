//
//  TipsTableViewCell.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 13.11.2022.
//

import UIKit

class TipsTableViewCell: UITableViewCell {
    
    static let id = "TipsTableViewCell"
    static var nib: UINib {
        return UINib(nibName: Self.id,
                     bundle: nil)
    }
    
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var bodyTextLabel: UILabel!
    
    
    func setupCell(by tip: Tip) {
        self.dateLabel.text = tip.dateText
        self.bodyTextLabel.text = tip.text
    }
    
}
