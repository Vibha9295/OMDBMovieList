//
//  ViewController.swift
//  OMDBMovieList
//
//  Created by Mac on 22/07/24.
//

import UIKit
import Combine

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

     let viewModel = MovieSearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        bindViewModel()
        fetchMovies()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 450
        tableView.accessibilityIdentifier = "movieTableView" 

    }

    private func setupSearchBar() {
        searchBar.accessibilityIdentifier = "Search"
        searchBar.accessibilityLabel = "Search"

        searchBar.delegate = self
    }

    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    private func fetchMovies() {
        viewModel.fetchMovies()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.search(for: "")
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search(for: searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        viewModel.search(for: "")
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        
        if indexPath.row == viewModel.movies.count - 1 {
            viewModel.loadNextPage()
        }
        
        return cell
    }
}
