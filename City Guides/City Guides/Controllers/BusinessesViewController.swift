//
//  BusinessesViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 03/05/1442 AH.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var pullView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
// MARK: - Constants & Variables
    let businessManager = BusinessesManager()
    var request = YelpRequest()
    var businesses = [BusinessRealm]()
    var filterBusinesses = [BusinessRealm]()
    var coor = CLLocationCoordinate2D() {
        didSet {
            print("coorBusi", coor )
            fetchBusinesses()
        }
    }
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
        LocationManager.shared.determineCurrentLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoor), name: NSNotification.Name(rawValue: "updateCoor"), object: nil)
    }
}

// MARK: - Functions
extension BusinessesViewController {
    func setupUI() {
        view.roundCorner(corners: [.topLeft, .topRight], radius: 30)
        pullView.roundCorner(corners: .allCorners, radius: 30)
        childView.roundCorner(corners: [.topLeft, .topRight], radius: 30)
    }
    
    @objc func updateCoor(_ notification: Notification) {
        if let data = notification.object as? CLLocationCoordinate2D {
            coor = data
        }
    }
    
    func fetchBusinesses() {
        if Reachability.isConnectedToNetwork() {
            BusinessesManager().fetchBusinesses(coordinates: coor) { [self] (busi) in
                businesses = Array(busi.businesses)
                filterBusinesses = Array(busi.businesses)
                for i in businesses {
                    let flag = RealmManager.saveBusinesses(i)
                    print("flag", flag)
                }
                cityNameLabel.text = businesses[0].location!.city
                self.collectionView.reloadData()
            }
        } else {
            print("Internet Connection not Available!")
            businesses = Array(RealmManager.getAllBusinesses()!)
            cityNameLabel.text = "" // I'll make it like this for now
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
        businessManager.businessStatus(statusLabel: cell.statusLabel, busi.isClosed)
         
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selected = collectionView.indexPathsForSelectedItems?.first {
            let busi = businesses[selected.item]
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
