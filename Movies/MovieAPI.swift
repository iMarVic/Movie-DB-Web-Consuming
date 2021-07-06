//
//  MovieAPI.swift
//  Movies
//
//  Created by Igor Marques Vicente on 01/07/21.
//

import UIKit

struct MovieAPI {
    
    let apiKey = "f0045eaf5301a7fa85688499ee7b981f"
    
    func requestMovie(get: String, page: Int = 1, completionHandler: @escaping ([Movie]) -> Void) {
        
        if page <= 0 { fatalError("Page should not be lower than 0") }
        
        let urlString = "https://api.themoviedb.org/3/movie/\(get)?api_key=\(apiKey)&page=\(page)"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias RMMovie = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["results"] as? [RMMovie]
            else {
                completionHandler([])
                return
            }
            
            var localMovies: [Movie] = []
            
            for moviesDictionary in movies {
                guard let id = moviesDictionary["id"] as? Int,
                      let title = moviesDictionary["title"] as? String,
                      let cover = moviesDictionary["poster_path"] as? String,
                      let description = moviesDictionary["overview"] as? String,
                      let rate = moviesDictionary["vote_average"] as? Double,
                      let genres =  moviesDictionary["genre_ids"] as? [Int]
                else { continue }
                let movie = Movie(id: id, title: title, cover: cover, description: description, rate: rate, genres: genres)
                localMovies.append(movie)
            }
            
            completionHandler(localMovies)
        }
        .resume()
        
    }
    
    func requestGenre(completionHandler: @escaping ([Int:String]) -> Void) {
        
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            typealias RMGenre = [String: Any]
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let dictionary = json as? [String: Any],
                  let movies = dictionary["genres"] as? [RMGenre]
            else {
                completionHandler([:])
                return
            }
            
            var localGenres: [Int:String] = [:]
            
            for moviesDictionary in movies {
                guard let id = moviesDictionary["id"] as? Int,
                      let name = moviesDictionary["name"] as? String
                else { continue }
                localGenres[id]=name
            }
    
            completionHandler(localGenres)
        }
        .resume()
        
    }
    
}
