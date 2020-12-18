//
//  BusinessesViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var pullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var request = YelpRequest()
    var businesses = [Business]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let collectionViewWidth = collectionView.bounds.size.width
        let numberOfItemsPerRow: CGFloat = 1
        var spaceBetweenItems: CGFloat = 0
        
        if let collectionViewFlowLayout = layout {
            spaceBetweenItems = collectionViewFlowLayout.minimumInteritemSpacing * (numberOfItemsPerRow - 1)
            let sectionInset = collectionViewFlowLayout.sectionInset
            spaceBetweenItems += sectionInset.left + sectionInset.right
        }
        let itemWidth = (collectionViewWidth - spaceBetweenItems) / numberOfItemsPerRow
        layout?.itemSize = CGSize(width: itemWidth, height: 220)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        request.fetchBusinesses { [self] (result) in
            switch result {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                businesses = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                print("Error fetching photos: \(error)")
            }
        }
    }
    
    func setupUI() {
        view.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        pullView.roundCorner(corners: .allCorners, radius: 30)
    }
}

// MARK: - DataSource Extenstion
extension BusinessesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "Cell"
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                               for: indexPath) as! CollectionViewCell
        let busi = businesses[indexPath.row]
        cell.label.text = busi.name
        return cell
    }
}

