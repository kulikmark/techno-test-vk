//
//  WeatherWidget.swift
//  techno-test-vk
//
//  Created by Марк Кулик on 03.09.2024.
//

import UIKit
import CoreLocation
import Alamofire
import SnapKit

struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    struct Main: Decodable {
        let temp: Double
    }
    
    struct Weather: Decodable {
        let description: String
    }
}

class WeatherWidget: UIViewController, CLLocationManagerDelegate {
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupLabels()
        setupLocationManager()
    }

    private func setupLabels() {
       
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 24)
        cityLabel.textColor = .white
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }

        let temperatureAndDescriptionStackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherDescriptionLabel])
        temperatureAndDescriptionStackView.axis = .horizontal
        temperatureAndDescriptionStackView.spacing = 8
        temperatureAndDescriptionStackView.alignment = .center
        view.addSubview(temperatureAndDescriptionStackView)
        temperatureAndDescriptionStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
        }

        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 20)
        temperatureLabel.textColor = .white

        weatherDescriptionLabel.textAlignment = .center
        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
        weatherDescriptionLabel.textColor = .white
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            fetchWeather(for: location)
            locationManager.stopUpdatingLocation()
        }
    }

    private func fetchWeather(for location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let apiKey = "6b0ade1f2a937b613ba647907e0e08d5"
        let urlString = "https://api.openweathermap.org/data/2.5/weather"
        
        let parameters: [String: String] = [
            "lat": "\(latitude)",
            "lon": "\(longitude)",
            "appid": apiKey,
            "units": "metric"
        ]
        
        AF.request(urlString, parameters: parameters)
            .validate() // Проверка ответа на ошибки HTTP
            .responseDecodable(of: WeatherResponse.self) { [weak self] response in
                switch response.result {
                case .success(let weatherResponse):
                    DispatchQueue.main.async {
                        self?.cityLabel.text = weatherResponse.name
                        self?.temperatureLabel.text = "\(weatherResponse.main.temp)°C / "
                        
                        let weatherDescriptions = weatherResponse.weather.map { $0.description }.joined(separator: ", ")
                        self?.weatherDescriptionLabel.text = weatherDescriptions
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
}
