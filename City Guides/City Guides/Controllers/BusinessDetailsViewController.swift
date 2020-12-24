//
//  BusinessDetailsViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import UIKit
import CoreLocation

class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var busiName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var busi: Business?
    var request = WeatherRequest()
    var coor = CLLocationCoordinate2D() {
        didSet {
            request.fetchWeather(coordinates: self.coor) { [self] (result) in
                switch result {
                case let .success(w):
                    print("Successfully found \(w).")
                    weather = w
                case let .failure(error):
                    print("Error fetching photos: \(error)")
                }
            }
        }
    }
    var weather: WeatherResponse? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coor = CLLocationCoordinate2D(latitude: (busi?.coordinates.latitude) ?? 0.0, longitude: (busi?.coordinates.longitude) ?? 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        businessInfo()
        setupUI()
    }
}

// MARK: - Functions
extension BusinessDetailsViewController {
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
    
    func weatherTime(_ time: String?) -> String {
        let dateObj = dateFormatter.date(from: time ?? "")
        dateFormatter.dateFormat = "h a"
        let date = dateFormatter.string(from: dateObj ?? Date())
        
        return date
    }
    
    func weatherImage(_ condition: String) -> UIImage {
        var image: UIImage?
        switch condition {
        case _ where (condition.contains("rain") == true):
            image = UIImage(systemName: "cloud.rain.fill")
        case _ where (condition.contains("cloud") == true):
            image = UIImage(systemName: "cloud.fill")
        case _ where (condition.contains("Overcast") == true):
          image = UIImage(systemName: "cloud.sun.fill")
        case _ where (condition.contains("clear") == true):
            image = UIImage(systemName: "sun.min.fill")
        case _ where (condition.contains("drizzle") == true):
           image = UIImage(systemName: "cloud.drizzle.fill")
        default:
            break
        }
        return image!
    }
}

extension BusinessDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather?.forecast.forecastday[0].hour.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forecase = weather?.forecast.forecastday[0]
        let hour = forecase?.hour[indexPath.row]
        
        let identifier = "Cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.setupCellShadow()
        
        cell.hourLabel.text = hour?.time
        cell.degreeLabel.text = String(hour?.tempC ?? 0) + " ℃"
        cell.weatherImage.image = weatherImage(hour?.condition.text ?? "")
        
        return cell
    }
}

// MARK: - Protocols
extension BusinessDetailsViewController: UpdateCoor {
    func passCoor(coor: CLLocationCoordinate2D) {
        self.coor = coor
    }
}
