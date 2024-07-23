//
//  UIImageView+Extensions.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, placeholder: UIImage? = nil) {
        let cacheKey = url.absoluteString
        if let cachedImage = ImageCache.shared.image(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        self.image = placeholder

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            ImageCache.shared.setImage(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        task.resume()
    }
}
