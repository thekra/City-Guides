//
//  BusinessesViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var pullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTF: UITextField! {
        didSet {
            searchTF.tintColor = UIColor.lightGray
            searchTF.setIcon(UIImage(systemName: "magnifyingglass")!)
        }
    }
    
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
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
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
        let fileUrl = URL(string: busi.imageURL)
        cell.businessImage.load(url: fileUrl!)
        cell.label.text = busi.name
        switch busi.isClosed {
        case false:
            cell.statusLabel.text = "Open"
            cell.statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case true:
            cell.statusLabel.text = "Closed"
            cell.statusLabel.textColor = #colorLiteral(red: 0.6325919628, green: 0.08559093624, blue: 0.2397931218, alpha: 1)
        }
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selected = collectionView.indexPathsForSelectedItems?.first {
            let busi = businesses[selected.row]
            let des = segue.destination as? BusinessDetailsViewController
            
            des?.busi = busi
        }
    }
}

