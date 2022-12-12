//
//  BikeDetailCollectionViewCell.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/20/22.
//

import UIKit

class BikeDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bikeImageView: UIImageView!
    var onReuse: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .white
    }

    func configure(with image: UIImage) {
        self.bikeImageView.image = image
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        bikeImageView.image = nil
    }

}
