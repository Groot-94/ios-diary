//
//  WeatherDataManager.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/09/01.
//

import Foundation
import CoreLocation
import UIKit

struct WeatherDataManager {
    private let apiKey = "aa0dcb07586dc281aa4c712309c7e38c&units=metric"
    private let session = URLSession.init(configuration: .default)
    
    func dataRequest(longitude: Double, latitude: Double, completion: @escaping(WeatherData?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")
        else { return }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard response != nil else { return }
            guard let jsonData = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            guard let data = try? jsonDecoder.decode(WeatherModel.self, from: jsonData) else { return }
            
            completion(data.weather.first)
        }
        
        dataTask.resume()
    }
    
    func iconRequest(id: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(id).png")
        else { return }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard response != nil else { return }
            guard let imageData = data else { return }
            
            completion(UIImage(data: imageData))
        }
        
        dataTask.resume()
    }
}
