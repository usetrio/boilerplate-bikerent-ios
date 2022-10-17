//
//  Bike.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/27/22.
//

import Foundation

struct Bike: Codable {

    let id: Int
    let candidateId: Int
    let name: String
    let type: String
    let bodySize: Int
    let maxLoad: Int
    let rate: Int
    let description: String
    let ratings: Float
    let imageUrls: [String]

}
