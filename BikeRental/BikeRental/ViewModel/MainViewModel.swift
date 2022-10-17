//
//  MainViewModel.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/27/22.
//

import Foundation

class MainViewModel {
    
    private(set) var bikes: [Bike] = [] {
        didSet {
            self.bikeListFetched()
        }
    }

    var bikeListFetched : (() -> ()) = {}

    func fetchBikes() {
        NetworkManager.fetchBikes { result in
            self.bikes = result
        }
    }
}
