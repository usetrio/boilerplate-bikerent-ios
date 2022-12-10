//
//  MainViewController.swift
//  BikeRental
//
//  Created by Gonzalo Barrios on 9/16/22.
//

import Foundation
import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    private var mainViewModel: MainViewModel!
    private let imageLoader = ImageLoader()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerView.layer.cornerRadius = 20
        self.headerView.backgroundColor = .mainBlue
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "BikeTableViewCell", bundle: .main), forCellReuseIdentifier: "BikeTableViewCell")

        setupViewModel()
    }

    private func setupViewModel() {
        self.mainViewModel = MainViewModel()
        self.mainViewModel.fetchBikes()
        self.mainViewModel.bikeListFetched = {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC" {
            guard let selectedPath = tableView.indexPathForSelectedRow else { return }
            if let target = segue.destination as? BikeDetailViewController {
                let bike = mainViewModel.bikes[selectedPath.row]
                target.bike = bike
            }
        }
    }

}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: self)
    }
}

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainViewModel.bikes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BikeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BikeTableViewCell", for: indexPath) as! BikeTableViewCell // swiftlint:disable:this force_cast
        let bike = mainViewModel.bikes[indexPath.row]

        guard let firstImage = bike.imageUrls.first,
              let imageURL = URL(string: firstImage) else { return cell }

        let token = ImageLoader.publicCache.loadImage(imageURL) { result in
          do {
            let image = try result.get()
            DispatchQueue.main.async {
              cell.bikeImageView.image = image
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

        cell.configure(with: bike)

        return cell
    }
}
