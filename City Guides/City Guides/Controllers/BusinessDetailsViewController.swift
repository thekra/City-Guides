//
//  BusinessDetailsViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import UIKit

class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var busiName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var busi: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessInfo()
        setupUI()
        
    }
    
    func businessInfo() {
        busiName.text = busi?.name
        let fileUrl = URL(string: busi!.imageURL)
        businessImage.load(url: fileUrl!)
        let address = busi?.location.displayAddress.joined(separator: "\n")
        addressLabel.text = address
    }
    
    func setupUI() {
        businessImage.roundCorner(corners: [.bottomLeft, .bottomRight], radius: 30)
        businessImage.shadow(alpha: 1)
    }
}
