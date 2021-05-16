//
//  ViewController.swift
//  WikipediaExample
//
//  Created by Zhanibek Lukpanov on 13.05.2021.
//

import UIKit
import WikipediaKit

final class ViewController: UIViewController, Coordinating {
    
    // MARK:- Properties
    var coordinator: Coordinator?
    
    let language = WikipediaLanguage("ru")
    
    var timer = Timer()
    var items = [WikipediaArticlePreview]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setuplayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK:- Layout
    private func setupSearchBar() {
        
        title = "Wiki Quick Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchVC = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchVC
        navigationItem.hidesSearchBarWhenScrolling = false
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.obscuresBackgroundDuringPresentation = false
        
        searchVC.searchBar.delegate = self
        
    }
    
    private func setuplayout() {
        setupSearchBar()
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        coordinator?.eventOccured(with: .detailScreen(model: item))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK:- UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self] _ in
            guard let self = self else { return }
            
            let _ = Wikipedia.shared.requestOptimizedSearchResults(language: self.language, term: searchText) {[weak self] (searchResults, error) in
                
                guard let self = self else { return }
                
                var resultItems = [WikipediaArticlePreview]()
                
                guard error == nil else { return }
                guard let searchResults = searchResults else { return }
                
                for result in searchResults.items {
                    resultItems.append(result)
                    self.items = resultItems
                    self.tableView.reloadData()
                }
                
            }
        
        })
    }
}
