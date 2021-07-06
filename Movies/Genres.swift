//
//  Genres.swift
//  Movies
//
//  Created by Igor Marques Vicente on 02/07/21.
//

import Foundation

final class Genres {
    var genres: [Int:String]
    static let instance: Genres = Genres()
    
    private init() {
        genres = [:]
    }
    
    func get(ids: [Int]) -> String {
        var genresStr: String = ""
        for id in ids {
            if genresStr.count > 0 {
                genresStr = genres[id]! + ", " + genresStr
            } else {
                genresStr = genres[id] ?? ""
            }
        }
        return genresStr
    }
}
