//
//  ViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    let fsqProvider = MoyaProvider<FoursquareService>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fsqProvider.request(.placePhotos(id: "56cde639cd1018a6e0049801")) { result in
            switch result {
                
            case .success(let responce):
                //print("Data",String(data: responce.data, encoding: .utf8))
                guard let photos = self.decodejson(type: Photos.self, from: responce.data) else {
                    return
                }
                photos.forEach { print($0.created_at) }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func decodejson<T:Decodable>(type: T.Type, from: Data?) -> T? {
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
/*
"{\"results\":[],\"context\":
{\"geo_bounds\":{\"circle\":{\"center\":{\"latitude\":28.076686,\"longitude\":-16.731949},\"radius\":1000}}}}"
*/
