import Foundation

class WeatherService {
    private let apiKey = "CA3YCCwcnNaLQftAs5H4VIyUCyMUPagm"
    
    // MARK: - LocationKey (Search value)
    func fetchLocationKey(for city: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://dataservice.accuweather.com/locations/v1/cities/search?q=\(city)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        print("Requisição para API: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Erro na requisição: \(error?.localizedDescription ?? "Desconhecido")")
                completion(nil)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Resposta JSON: \(jsonString)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                print("JSON Decodificado:", json ?? "Nenhum dado encontrado")
                
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
    
    // MARK: - Location Key by Coordinates
    func fetchLocationKeyCoordinates(forLatitude latitude: Double, longitude: Double, completion: @escaping (String?) -> Void ) {
        let urlString = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(apiKey)&q=\(latitude),\(longitude)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) {data, response, error in guard let data = data, error == nil else {
            completion(nil)
            return
        }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let locationKey = json?["Key"] as? String {
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
        let urlString = "https://dataservice.accuweather.com/currentconditions/v1/\(locationKey)?apikey=\(apiKey)&details=true"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        print("Requisição para API (Weather): \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Erro na requisição: \(error?.localizedDescription ?? "Desconhecido")")
                completion(nil)
                return
            }
            
            // Convertendo os dados em uma String para inspecionar o JSON bruto
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Resposta JSON (Weather): \(jsonString)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                print("JSON Decodificado (Weather):", json ?? "Nenhum dado encontrado")
                
                if let weatherData = json?.first,
                   let temperatureInfo = weatherData["Temperature"] as? [String: Any],
                   let metric = temperatureInfo["Metric"] as? [String: Any],
                   let temp = metric["Value"] as? Double,
                   let humidity = weatherData["RelativeHumidity"] as? Double,
                   let wind = weatherData["Wind"] as? [String: Any],
                   let windSpeed = wind["Speed"] as? [String: Any],
                   let windSpeedMetric = windSpeed["Metric"] as? [String: Any],
                   let windValue = windSpeedMetric["Value"] as? Double,
                   let weatherText = weatherData["WeatherText"] as? String {
                    
                    let weather = Weather(
                        city: "Cidade desconhecida",
                        temperature: String(format: "%.1f", temp),
                        description: weatherText,
                        humidity: String(format: "%.1f", humidity),
                        wind: String(format: "%.1f", windValue)
                    )
                    
                    completion(weather)
                    
                } else {
                    print("Erro: Dados de clima não encontrados ou inválidos.")
                    completion(nil)
                }

            } catch {
                print("Erro ao decodificar JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
