//
//  MovieCell.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(systemName: "photo") 
        titleLabel.text = nil
        yearLabel.text = nil
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        
        if let url = URL(string: movie.poster) {
            posterImageView.load(url: url, placeholder: UIImage(systemName: "photo"))
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func setupViews() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        titleLabel.numberOfLines = 0
        yearLabel.numberOfLines = 0
    }
}
