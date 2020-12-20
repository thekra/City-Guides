//
//  CollectionViewCell.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
//        conView.roundCorner(corners: [.bottomLeft, .bottomRight], radius: 20)
//        conView.shadow(radius: 20, alpha: 0.3, y: 100)
//        conView.shadow1()
    }
}
