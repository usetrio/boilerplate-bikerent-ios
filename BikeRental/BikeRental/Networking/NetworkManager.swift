//
//  NetworkManager.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/27/22.
//

import Foundation
import Alamofire

class NetworkManager {

    class func fetchBikes(completionHandler: @escaping ([Bike]) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": Constants.token,
            "Accept": "application/json"
        ]

        AF.request(Constants.bikeListURL, headers: headers).responseDecodable(of: [Bike].self) { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                let bikeList: [Bike] = try! decoder.decode([Bike].self, from: data) // swiftlint:disable:this force_try
                completionHandler(bikeList)
            case .failure(let error):
                print(error)
                completionHandler([])
            }
        }
    }
}
