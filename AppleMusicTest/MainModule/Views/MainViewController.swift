//
//  ViewController.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import UIKit

final class MainViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: properties
    
    var presenter: MainPresenterProtocol?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSearchBar()
        setupSubviews()
        configureTableView()
        setupConstraints()
    }
    
    //MARK: LC helpers
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Плейлисты"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать в плейлистах"
        navigationItem.searchController = searchController
    }
    
    private func setupSubviews() {
        self.view.addSubview(tableView)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseId)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

//MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseId, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        guard let data = presenter?.getAlbum(for: indexPath) else { return UITableViewCell() }
        
        cell.loadImage(image: nil)
        cell.configure(with: data)
        presenter?.fetchImageData(for: indexPath, completion: { data in
            guard let data = data, let image = UIImage(data: data) else { return }
            cell.loadImage(image: image)
        })
        
        return cell
    }
}

//MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let editAction = UIAction(title: "Редактировать", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                    self?.presenter?.didTapEditAlbum(at: indexPath)
                }
                let hideAction = UIAction(title: "Скрыть", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.presenter?.didTapHideAlbum(at: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [editAction, hideAction])
            }
        
        return config
    }
}

//MARK: UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        presenter?.setFilter(filter: searchController.searchBar.text!)
    }

}

//MARK: MainViewProtocol

extension MainViewController: MainViewProtocol {
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.presenter?.fetchPlaylist()
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    func showAlbumEditingMenu(album: Album) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField : UITextField!) in
            textField.text = album.title
            textField.delegate = self
        }
        
        let save = UIAlertAction(title: "Готово", style: .default, handler: { [weak self] _ in
            let textField = alert.textFields![0] as UITextField
            self?.presenter?.updateAlbumTitle(with: album.image, on: textField.text!)
        })
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(cancel)
        alert.addAction(save)

        self.present(alert, animated: true, completion: nil)
    }
    
}

