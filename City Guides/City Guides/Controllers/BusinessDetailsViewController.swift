//
//  BusinessDetailsViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import UIKit

class BusinessDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var busiName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var busi: Business?
    var request = WeatherRequest()
    var weather: WeatherResponse? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        businessInfo()
        setupUI()
        request.fetchWeather { [self] (result) in
            switch result {
            case let .success(photos):
                print("Successfully found \(photos) photos.")
                weather = photos
//                DispatchQueue.main.async {
//                    collectionView.reloadData()
//                }
            case let .failure(error):
                print("Error fetching photos: \(error)")
            }
        }
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

extension BusinessDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather?.forecast.forecastday[0].hour.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "Cell"
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                               for: indexPath) as! WeatherCollectionViewCell
        let forecase = weather?.forecast.forecastday[0]
        let hour = forecase?.hour[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let d = hour?.time
        let dateObj = dateFormatter.date(from: d ?? "")
        dateFormatter.dateFormat = "h a"
        let date = dateFormatter.string(from: dateObj ?? Date())
        
        cell.hourLabel.text = date
        cell.degreeLabel.text = String(hour?.tempC ?? 0) + " ℃"
        switch hour?.condition.text {
        case _ where (hour?.condition.text.contains("rain") == true):
            cell.weatherImage.image = UIImage(systemName: "cloud.rain.fill")
        case _ where (hour?.condition.text.contains("cloud") == true):
            cell.weatherImage.image = UIImage(systemName: "cloud.fill")
        case _ where (hour?.condition.text.contains("Overcast") == true):
            cell.weatherImage.image = UIImage(systemName: "cloud.sun.fill")
        case _ where (hour?.condition.text.contains("clear") == true):
            cell.weatherImage.image = UIImage(systemName: "sun.min.fill")
        case _ where (hour?.condition.text.contains("drizzle") == true):
            cell.weatherImage.image = UIImage(systemName: "cloud.drizzle.fill")
        default:
            break
        }
//        let fileUrl = URL(string:(hour?.condition.icon) ?? "" )
//        if let url = fileUrl {
//            cell.weatherImage.load(url: url )
//        }
        
        cell.layer.cornerRadius = 15.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        
        return cell
    }
}
