//
//  FoursquareProvider.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 30.08.2022.
//

import Foundation
import Moya

class NetworkProvider {
    
   lazy var foursquare = MoyaProvider<FoursquareService>()
   lazy var openweather = MoyaProvider<OpenWeatherMapService>()
    
   func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let error {
            print("data has been not decoded : \(error.localizedDescription)")
            return nil
        }
    }

}
