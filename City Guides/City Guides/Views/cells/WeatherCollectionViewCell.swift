//
//  WeatherCollectionViewCell.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import UIKit
import Lottie
class WeatherCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherAni: AnimationView!
    
    override func awakeFromNib() {
        weatherAni.loopMode = .autoReverse
        weatherAni.play()
    }
}
