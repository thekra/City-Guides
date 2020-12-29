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
    @IBOutlet weak var toggleButton: UIButton!
    
    
// MARK: - Constants & Variables
    let businessManager = BusinessDetailsManager()
    var busi: BusinessRealm?
    var busiWeather = BusinessWeather()
    var request = WeatherRequest()
    var coor = CLLocationCoordinate2D() {
        didSet {
            fetchWeather()
        }
    }
    var weather: WeatherResponseR? {
        didSet {
            currentDateLabel.text = businessManager.dateFormat(date: weather?.forecast!.forecastday[0].date, from: .midium, to: .dayNameMD)//weatherInfo(date: weather?.forecast!.forecastday[0].date)
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    var tableViewVisible = true
    
// MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = tableViewVisible
        coor = CLLocationCoordinate2D(latitude: (busi?.coordinates?.latitude) ?? 0.0, longitude: (busi?.coordinates?.longitude) ?? 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        businessInfo()
        setupUI()
    }
    
    @IBAction func showMoreForecast(_ sender: UIButton) {
        let willExpand = tableView.isHidden
        let buttonNewTitle = willExpand ? "Show Less" : "Show More"
        self.tableView.isHidden = !willExpand
        if willExpand {
            self.toggleButton.setTitle(buttonNewTitle, for: .normal)
        } else  if !willExpand {
            self.toggleButton.setTitle(buttonNewTitle, for: .normal)
        }
    }
}

// MARK: - Functions
extension BusinessDetailsViewController {
    
    func fetchWeather() {
        if Reachability.isConnectedToNetwork() {
            WeatherManager().fetchWeather(coordinates: coor) { [self] (w) in
                print("Successfully found \(w).")
                weather = w
                busiWeather.weather = w
                busiWeather.businessID = busi!.id
                let flag = RealmManager.saveWeather(busiWeather)
                print("save", flag)
            }
        } else {
            if let w = RealmManager.getWeatherBy(id: busi!.id) {
                busiWeather = w
                weather = w.weather
            } else {
                currentDateLabel.isHidden = true
                toggleButton.isHidden = true
                print("No weather Info is available")
            }
        }
    }
    
    func businessInfo() {
        busiName.text = busi?.name
        let fileUrl = URL(string: busi!.imageURL)
        businessImage.load(url: fileUrl!) // check for connection
        let address = busi?.location?.displayAddress.joined(separator: "\n")
        addressLabel.text = address
        phoneLabel.text = businessManager.checkPhoneAvailablility(phone: busi?.phone)
        businessManager.addStarsToStackView(rating: busi?.rating, stackView: starStackView)
    }

    func setupUI() {
        businessImage.roundCorner(corners: [.bottomLeft, .bottomRight], radius: 30)
        businessImage.shadow(alpha: 1)
    }
}

// MARK: - Weather Forecast TableView
extension BusinessDetailsViewController: UITableViewDataSource ,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather?.forecast!.forecastday.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecase = weather?.forecast!.forecastday[indexPath.row]
        
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.textLabel?.text = businessManager.dateFormat(date: forecase?.date, from: .midium, to: .dayNameMD)//weatherInfo(date: forecase?.date)
        cell.detailTextLabel?.text = String(forecase?.day?.avgtempC ?? 0.0)
        return cell
    }
}

// MARK: - Today's weather CollectionView
extension BusinessDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather?.forecast!.forecastday[0].hour.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forecase = weather?.forecast!.forecastday[0]
        let hour = forecase?.hour[indexPath.item]
        
        let identifier = "Cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.setupCellShadow()
        
        cell.hourLabel.text = businessManager.dateFormat(date: hour?.time, from: .wholeDate, to: .time)
        cell.degreeLabel.text = String(hour?.tempC ?? 0) + " ℃"
        cell.weatherImage.image = businessManager.weatherImage(hour?.condition?.text ?? "")
        
        return cell
    }
}
