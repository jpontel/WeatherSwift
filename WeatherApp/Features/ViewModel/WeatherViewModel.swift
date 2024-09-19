//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Guigo on 17/09/24.
//

import CoreLocation
import Foundation

class WeatherViewModel: NSObject, ObservableObject, UserLocationProtocol {
    @Published var city: String = "Curitiba"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var humidity: String = ""
    @Published var wind: String = ""
    
    private let weatherService = WeatherService()
    private var locationManager: LocationManager?
    
    override init() {
        super.init()
        locationManager = LocationManager(userLocationProtocol: self)
    }
    
    func requestLocationPermission() {
        locationManager?.requestLocation()
    }
    
    func onUserLocationReceived(latitude: Double, longitude: Double) {
        weatherService.fetchLocationKeyCoordinates(forLatitude: latitude, longitude: longitude) { [weak self] locationKey in
            guard let locationKey = locationKey else {
                print("Location key não encontrado.")
                return
            }
            
            // Chamar o serviço de clima com a locationKey recebida
            self?.weatherService.fetchWeather(for: locationKey) { weather in
                guard let weather = weather else { return }
                DispatchQueue.main.async {
                    self?.temperature = "\(weather.temperature)ºC"
                    self?.weatherDescription = weather.description.capitalized
                    self?.humidity = "\(weather.humidity)%"
                    self?.wind = "\(weather.wind) km/h"
                }
            }
        }
    }

    
    func onUserLocationPermissionGranted() {
        locationManager?.requestLocation()
    }
    
    func onUserLocationPermissionDenied() {
        print("Permnission Denied!")
    }
    
    func onUserLocationError() {
        print("Error on the location :/")
    }
    
    // MARK: - LocationAPI Call
    func fetchWeather(for city: String) {
        weatherService.fetchLocationKey(for: city) { [weak self] locationKey in
            guard let locationKey = locationKey else {
                print("Location key não encontrado")
                return
            }
            
            // MARK: - ClimateAPI Call
            self?.weatherService.fetchWeather(for: locationKey) { weather in
                guard let weather = weather else { return }
                DispatchQueue.main.async {
                    self?.city = city
                    self?.temperature = "\(weather.temperature)ºC"
                    self?.weatherDescription = weather.description.capitalized
                    self?.humidity = "\(weather.humidity)%"
                    self?.wind = "\(weather.wind) km/h"
                    
                }
            }
        }
    }
}

