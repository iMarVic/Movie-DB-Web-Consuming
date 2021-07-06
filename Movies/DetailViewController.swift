//
//  DetailViewController.swift
//  Movies
//
//  Created by Igor Marques Vicente on 02/07/21.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var oterviewLabel: UILabel!
    
    var movie: Movie?
    var genres: Genres = Genres.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else { return }
        let url = URL(string:"https://image.tmdb.org/t/p/w500/\(movie.cover)")!
        imageView.load(url: url)
        titleLabel.text = movie.title
        genreLabel.text = genres.get(ids: movie.genres)
        rateLabel.text = String(movie.rate)
        oterviewLabel.text = movie.description
    }

}
