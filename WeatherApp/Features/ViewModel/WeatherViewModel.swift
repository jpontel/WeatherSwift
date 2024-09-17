//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Guigo on 17/09/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var temperature: String = "--"
    @Published var description: String = "--"
    
    private let weatherService = WeatherService()
    
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
                    self?.description = weather.description.capitalized
                }
            }
        }
    }
}

