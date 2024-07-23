//
//  Movie.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import Foundation
struct Movie: Codable {
    let title: String
    let year: String
    let poster: String
    let imdbID: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case imdbID = "imdbID"
    }
}
