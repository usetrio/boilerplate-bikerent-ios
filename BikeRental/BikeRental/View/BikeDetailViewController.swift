//
//  BikeDetailViewController.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/20/22.
//

import Foundation
import UIKit
import MapKit

class BikeDetailViewController: UIViewController {

    // MARK: IBoutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bodySizeLabel: UILabel!
    @IBOutlet weak var stackViewSeparator: UIView!
    @IBOutlet weak var stackViewSeparator2: UIView!
    @IBOutlet weak var maxLoadLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var bikeNameLabel: UILabel!
    @IBOutlet weak var bikeDescriptionLabel: UILabel!
    @IBOutlet weak var bikeTypeView: UIView!
    @IBOutlet weak var likeContainer: UIView!
    @IBOutlet weak var bikeTypeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rentBikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weeklyPrice: UILabel!

    var bike: Bike?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureUI()
        updateUI()
        configureMapView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.30) {
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.30) {
            self.view.backgroundColor = .clear
        }
    }

    // MARK: Config

    private func configureUI() {
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 20
        stackView.layer.borderColor = UIColor.appLightGray.cgColor
        stackViewSeparator.backgroundColor = UIColor.appLightGray
        stackViewSeparator2.backgroundColor = UIColor.appLightGray

        bottomContainer.backgroundColor = .mainBlue
        bottomContainer.clipsToBounds = true
        bottomContainer.layer.cornerRadius = 20
        bottomContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        containerView.layer.cornerRadius = 30
        pageControl.numberOfPages = bike?.imageUrls.count ?? 0
        pageControl.currentPage = 0
        likeContainer.layer.borderColor = UIColor.appLightGray.cgColor
        likeContainer.layer.cornerRadius = 20
        likeContainer.layer.borderWidth = 1
        rentBikeButton.layer.cornerRadius = 20
        bikeTypeView.layer.cornerRadius = 13
        scrollView.isScrollEnabled = true
        scrollView.layer.cornerRadius = 20
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.backgroundColor = .mainBlue
        mapView.layer.cornerRadius = 20
    }

    private func updateUI() {
        guard let bike = bike else { return }

        self.bodySizeLabel.text = "\(bike.bodySize)"
        self.maxLoadLabel.text = "\(bike.maxLoad)"
        self.ratingLabel.text = "\(bike.ratings)"
        self.bikeNameLabel.text = bike.name
        self.bikeTypeLabel.text = bike.type
        self.bikeDescriptionLabel.text = bike.description
        self.priceLabel.text = "\(bike.rate) €"
        self.weeklyPrice.text = "\(bike.rate * 7) €"
    }

    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "BikeDetailCollectionViewCell", bundle: .main),
                                forCellWithReuseIdentifier: "BikeDetailCollectionViewCell")
    }

    private func configureMapView() {
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        mapView.centerToLocation(initialLocation)
    }
}

// MARK: Extensions

extension BikeDetailViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(
            (collectionView.contentOffset.x / collectionView.frame.width)
                .rounded(.toNearestOrAwayFromZero))
    }
}

extension BikeDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bike?.imageUrls.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "BikeDetailCollectionViewCell", for: indexPath)
            as? BikeDetailCollectionViewCell {

            guard let imageURL = bike?.imageUrls[indexPath.row],
                  let imageURL = URL(string: imageURL) else { return cell }

            let token = ImageLoader.publicCache.loadImage(imageURL) { result in
                do {
                    let image = try result.get()
                    DispatchQueue.main.async {
                        cell.configure(with: image)
                    }
                } catch {
                    print(error)
                }
            }

            cell.onReuse = {
                if let token = token {
                    ImageLoader.publicCache.cancelLoad(token)
                }
            }

            return cell
        }

        return UICollectionViewCell()
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
