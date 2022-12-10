//
//  BikeTableViewCell.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/16/22.
//

import UIKit

class BikeTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bikeTypeLabel: UILabel!
    @IBOutlet weak var lineSeparatorView: UIView!
    @IBOutlet weak var bikeTypeContainer: UIView!
    @IBOutlet weak var bikeImageView: UIImageView!
    @IBOutlet weak var bikeNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var onReuse: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        bikeTypeLabel.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        bikeTypeContainer.layer.cornerRadius = 13
        backgroundColor = .clear
        selectionStyle = .none
        containerView.layer.borderColor = UIColor.appLightGray.cgColor
        containerView.layer.borderWidth = 1
        lineSeparatorView.backgroundColor = .appLightGray
    }

    func configure(with bike: Bike) {
        bikeNameLabel.text = bike.name
        bikeTypeLabel.text = bike.type
        priceLabel.text = "\(bike.rate) €/"
    }

    override func prepareForReuse() {
      super.prepareForReuse()
      onReuse()
      bikeImageView.image = nil
    }
}
