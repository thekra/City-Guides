//
//  BusinessesViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var pullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Constants & Variables
    var request = YelpRequest()
    var businesses = [Business]()
    var filterBusinesses = [Business]()
    var isFiltered = false
    
    // MARK: - LifeCycles
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
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        request.fetchBusinesses { [self] (result) in
            switch result {
            case let .success(business):
                print("Successfully found \(business.count) photos.")
                businesses = business
                filterBusinesses = business
                DispatchQueue.main.async {
                    cityNameLabel.text = business[0].location.city
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                print("Error fetching photos: \(error)")
            }
        }
    }
}

// MARK: - Functions
extension BusinessesViewController {
    func setupUI() {
        view.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        pullView.roundCorner(corners: .allCorners, radius: 30)
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
    }
    
    func businessStatus(statusLabel:UILabel, _ isClosed: Bool) {
        switch isClosed {
        case false:
            statusLabel.text = "Open"
            statusLabel.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case true:
            statusLabel.text = "Closed"
            statusLabel.textColor = #colorLiteral(red: 0.6325919628, green: 0.08559093624, blue: 0.2397931218, alpha: 1)
        }
    }
}

// MARK: - DataSource Extenstion
extension BusinessesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltered ? filterBusinesses.count : businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "Cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionViewCell
        cell.setupCellShadow()
        
        let businessestList = isFiltered ? filterBusinesses : businesses
        let busi = businessestList[indexPath.row]
        let fileUrl = URL(string: busi.imageURL)
        cell.businessImage.load(url: fileUrl!)
        cell.label.text = busi.name
        businessStatus(statusLabel: cell.statusLabel, busi.isClosed)
         
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

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterBusinesses = businesses
        } else {
            filterBusinesses = businesses.filter{$0.name.localizedCaseInsensitiveContains(searchText)}
        }
        isFiltered = true
        collectionView.reloadData()
    }
}
