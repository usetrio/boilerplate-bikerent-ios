//
//  UIImageView+Extensions.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/28/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
