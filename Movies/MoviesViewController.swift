//
//  ViewController.swift
//  Movies
//
//  Created by Igor Marques Vicente on 01/07/21.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    let movieAPI = MovieAPI()
    var popular: [Movie] = []
    var nowPlaying: [Movie] = []
    var genres: Genres = Genres.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        movieAPI.requestGenre(completionHandler: { genres in
            self.genres.genres = genres
        })
        
        movieAPI.requestMovie(get: "popular", completionHandler: { popular in
            
            self.popular = popular
            
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
            
        })

        movieAPI.requestMovie(get: "now_playing", completionHandler: { nowPlaying in
            
            self.nowPlaying = nowPlaying
            
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return popular.count
        } else if section == 1 {
            return nowPlaying.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell

        if indexPath.section == 0 {
            let url = URL(string:"https://image.tmdb.org/t/p/w500/\(popular[indexPath.row].cover)")!
            cell.coverImageView.load(url: url)
            cell.titleLabel.text = popular[indexPath.row].title
            cell.descriptionLabel.text = popular[indexPath.row].description
            cell.rateLabel.text = String(popular[indexPath.row].rate)

        } else if indexPath.section == 1 {
            let url = URL(string:"https://image.tmdb.org/t/p/w500/\(nowPlaying[indexPath.row].cover)")!
            cell.coverImageView.load(url: url)
            cell.titleLabel.text = nowPlaying[indexPath.row].title
            cell.descriptionLabel.text = nowPlaying[indexPath.row].description
            cell.rateLabel.text = String(nowPlaying[indexPath.row].rate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Popular Movies"
        } else if section == 1 {
            return "Now Playing"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "goToDetails", sender: popular[indexPath.row] )
        } else if indexPath.section == 1 {
            performSegue(withIdentifier: "goToDetails", sender: nowPlaying[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView = segue.destination as? DetailViewController else { return }
        guard let movie = sender as? Movie else { return }

        detailView.movie = movie
    }
    
}
