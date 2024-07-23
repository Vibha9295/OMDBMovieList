//
//  ImageCache.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import Foundation
import UIKit
final class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

