//
//  WeatherManager.swift
//  Clima
//
//  Created by John Hur on 2021/10/20.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

// Delegate(위임자)를 Protocol로 걸어주어 WeatherModel에 날씨를 업데이트 하도록 위임하는 Delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct WeatherManager {
    // 개인 API 호출
    // http로 호출하게 되면 누군가 내 appid를 가로 챌수 있기때문에
    // https로 암호화 해서 호출해야 에러가 나지 않음
    let weatherURL = "Your Personal API Code"
    
    var delegate: WeatherManagerDelegate?
    
    // 개인 API 호출 키에다가 사용자가 원하는 도시 이름을 호출할 수 있도록 아래와 같이 작성
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // 1. Create a URL
        // if let 바인딩으로 urlString이 입력되면 다음으로 넘어가게 됨
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            // 실질적으로 네트워킹 하는 하는 API 생성
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            // 해당 URL로 이동하여 네트워크를 통해 데이터를 수집하고 본 사용자에게로 돌아오는 일
            // let task = session.dataTask(with: url, completionHandler: handler(data:response:error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        // 데이터가 안전하게 바인딩이 되면 weather 변수가 업데이트 될 수 있도록 알려줌
                        // 현재 Delegate의 자기 자신이라는 것을 알려주기 위해 self 키워드를 써줌
                        self.delegate?.didUpdateWeather(weather: weather)
                        
                    }
                }
            }
            // 4. Start the task
            // 일을 시작하도록 만드는 함수
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            print(weather.temperatureString)
            
//            print("\(decodedData.name)의 온도 : \(decodedData.main.temp), 상태 : \(decodedData.weather.description)")
        } catch {
            print(error)
            return nil
        }
    }
    
}

