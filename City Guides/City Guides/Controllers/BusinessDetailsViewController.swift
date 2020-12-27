//
//  BusinessDetailsViewController.swift
//  City Guides
//
//  Created by Thekra Abuhaimed. on 05/05/1442 AH.
//

import UIKit
import CoreLocation

class BusinessDetailsViewController: UIViewController {

// MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var busiName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    
// MARK: - Constants & Variables
    var busi: BusinessRealm?
    var request = WeatherRequest()
    var coor = CLLocationCoordinate2D() {
        didSet {
            request.fetchWeather(coordinates: self.coor) { [self] (result) in
                switch result {
                case let .success(w):
                    print("Successfully found \(w).")
                    weather = w
                case let .failure(error):
                    print("Error fetching weather: \(error)")
                }
            }
        }
    }
    var weather: WeatherResponse? {
        didSet {
            currentDateLabel.text = weatherInfo(date: weather?.forecast.forecastday[0].date)
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
//        let dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm"
//            return formatter
//        }()
    
// MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Businesssss: ", busi?.location)
        //        print("busi?.coordinates?.latitude", busi?.coordinates?.latitude)
        coor = CLLocationCoordinate2D(latitude: (busi?.coordinates?.latitude) ?? 0.0, longitude: (busi?.coordinates?.longitude) ?? 0.0)
        print(coor)
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
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
        let address = busi?.location?.displayAddress.joined(separator: "\n")
        addressLabel.text = address
        if busi?.phone == "" {
            phoneLabel.text = "phone number is not available"
        } else {
            phoneLabel.text = busi?.phone
        }
        switch Double(busi!.rating) {
        case 5:
            for _ in 0..<5 {
                starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.fill.rawValue)))
            }
        case 4...4.5:
            for _ in 0..<4 {
                starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.fill.rawValue)))
            }
            starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.empty.rawValue)))
            
        case 3...3.5:
            for _ in 0..<3 {
                starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.fill.rawValue)))
            }
            for _ in 0..<2 {
            starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.empty.rawValue)))
            }
            
        case 2...2.5:
            for _ in 0..<2 {
                starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.fill.rawValue)))
            }
            for _ in 0..<3 {
            starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.empty.rawValue)))
            }
            
        case 1...1.5:
                starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.fill.rawValue)))
            
            for _ in 0..<4 {
            starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.empty.rawValue)))
            }
        default:
            starStackView.addArrangedSubview(UIImageView(image: UIImage(systemName: Star.empty.rawValue)))
        }
        
    }
    
    func weatherInfo(date: String?) -> String {
//        let date = weather?.forecast.forecastday[0].date
//        print("date", date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.date(from: date ?? "")
        dateFormatter.dateFormat = "EEEE, MMM d"
        let current = dateFormatter.string(from: dateObj ?? Date())
        
        return current
//        currentDateLabel.text = current
    }
    
    func setupUI() {
        businessImage.roundCorner(corners: [.bottomLeft, .bottomRight], radius: 30)
        businessImage.shadow(alpha: 1)
    }
    //    func weatherTime(_ time: String?) -> String {
    //        let dateObj = dateFormatter.date(from: time ?? "")
    //        dateFormatter.dateFormat = "h a"
    //        let date = dateFormatter.string(from: dateObj ?? Date())
    //
    //        return date
    //    }
    
    func weatherImage(_ condition: String) -> UIImage {
        var image: UIImage?
        switch condition {
        case _ where (condition.contains("rain") == true):
            image = UIImage(systemName: WeatherImage.cloudRain.rawValue)
        case _ where (condition.contains("cloud") == true):
            image = UIImage(systemName: WeatherImage.cloud.rawValue)
        case _ where (condition.contains("Overcast") == true):
            image = UIImage(systemName: WeatherImage.cloudSun.rawValue)
        case _ where (condition.contains("clear") == true):
            image = UIImage(systemName: WeatherImage.sunMin.rawValue)
        case _ where (condition.contains("drizzle") == true):
            image = UIImage(systemName: WeatherImage.cloudDrizzle.rawValue)
        default:
            image = UIImage(systemName: "cloud") // re-check here
        }
        return image!
    }
}

extension BusinessDetailsViewController: UITableViewDataSource ,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather?.forecast.forecastday.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecase = weather?.forecast.forecastday[indexPath.row]
        
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.textLabel?.text = weatherInfo(date: forecase?.date)
        cell.detailTextLabel?.text = String(forecase?.day.avgtempC ?? 0.0)
        return cell
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
        let d = hour?.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateObj = dateFormatter.date(from: d ?? "")
        
        dateFormatter.dateFormat = "h a"
        let date = dateFormatter.string(from: dateObj ?? Date())
        cell.hourLabel.text = date
        cell.degreeLabel.text = String(hour?.tempC ?? 0) + " ℃"
        cell.weatherImage.image = weatherImage(hour?.condition.text ?? "")
        
        return cell
    }
}

// MARK: - Enums
extension BusinessDetailsViewController {
    enum Star: String {
        case fill = "star.fill"
        case empty = "star"
    }
    
    enum WeatherImage: String {
        case cloudRain = "cloud.rain.fill"
        case cloud = "cloud.fill"
        case cloudSun = "cloud.sun.fill"
        case sunMin = "sun.min.fill"
        case cloudDrizzle = "cloud.drizzle.fill"
    }
}

// MARK: - Protocols
extension BusinessDetailsViewController: UpdateCoor {
    func passCoor(coor: CLLocationCoordinate2D) {
        self.coor = coor
    }
}
