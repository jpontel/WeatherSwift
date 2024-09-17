//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Guigo on 17/09/24.
//

import Foundation

class WeatherService {
    private let apiKey = "CA3YCCwcnNaLQftAs5H4VIyUCyMUPagm"
    
    // MARK: - LocationKey
    func fetchLocationKey(for city: String, completion: @escaping (String?) -> Void) {
        let urlString = "http://dataservice.accuweather.com/locations/v1/cities/search?q=\(city)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                if let location = json?.first,
                   let locationKey = location["Key"] as? String {
                    completion(locationKey)
                } else {
                    completion(nil)
                }
            } catch {
                print("Erro ao decodificar JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - Climate conditions with Location Key
    func fetchWeather(for locationKey: String, completion: @escaping (Weather?) -> Void) {
        let urlString = "http://dataservice.accuweather.com/currentconditions/v1/\(locationKey)?apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                if let weatherData = json?.first,
                   let temperatureInfo = weatherData["Temperature"] as? [String: Any],
                   let metric = temperatureInfo["Metric"] as? [String: Any],
                   let temp = metric["Value"] as? Double,
                   let weatherText = weatherData["WeatherText"] as? String {
                    let weather = Weather(city: "Cidade desconhecida", temperature: temp, description: weatherText)
                    completion(weather)
                }
            } catch {
                print("Erro ao decodificar JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

