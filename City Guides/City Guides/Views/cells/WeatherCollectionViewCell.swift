//
//  WeatherCollectionViewCell.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
//        childView.roundCorner(corners: .allCorners, radius: 30)
    }
}
