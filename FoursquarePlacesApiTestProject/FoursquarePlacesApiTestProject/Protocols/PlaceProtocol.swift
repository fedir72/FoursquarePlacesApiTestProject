//
//  PlaceProtocol.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation

protocol PlaceProtocol {
    var name: String { get }
    var lat: Double { get }
    var lon: Double { get }
    var country: String? { get }
    var state: String? { get }  
}
