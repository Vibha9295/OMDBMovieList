//
//  Constants.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import Foundation
struct ErrorMessages {
    static let invalidURL = "Invalid URL"
    static let noDataReceived = "No data received"
    static let decodeError = "Failed to decode response"
    static let unknownError = "An unknown error occurred. Please try again."
}
// Constants for API
struct APIConstants {
    static let apiKey = "ccf94dca"
    static let baseURL = "https://www.omdbapi.com/"
}
