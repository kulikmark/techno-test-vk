//
//  CityWidget.swift
//  techno-test-vk
//
//  Created by Марк Кулик on 03.09.2024.
//

import UIKit
import CoreLocation
import SnapKit

class CityWidget: UIViewController, CLLocationManagerDelegate {
    private let locationLabel = UILabel()
    private let cityLabel = UILabel()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        setupLabels()
        setupLocationManager()
    }

    private func setupLabels() {
        locationLabel.text = "Ваше местоположение:"
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.systemFont(ofSize: 20)
        locationLabel.textColor = .white
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }

       
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 24)
        cityLabel.textColor = .white
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
        }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location updated: \(location)")
            fetchCityName(for: location)
            locationManager.stopUpdatingLocation()
        }
    }

    private func fetchCityName(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                return
            }
            DispatchQueue.main.async {
                self?.cityLabel.text = placemark.locality
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
}

