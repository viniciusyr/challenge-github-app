//
//  ViewController.swift
//  GitHubApp
//
//  Created by Rodrigo Borges on 29/09/21.
//

import UIKit

final class ListViewController: UIViewController {

    private lazy var listView: ListView = {
        let listView = ListView()
        listView.delegate = self
        return listView
    }()

    private let service = Service()
    
    // MARK: - UI Components
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Type a GitHub user name"
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let settingsButton = UIBarButtonItem()
        settingsButton.title = "Settings"
        settingsButton.style = .plain
        settingsButton.tintColor = .systemBlue
        settingsButton.target = self
        settingsButton.action = #selector(navigationSettingsViewController)
        return settingsButton
    }()

    // MARK: Initializations
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        setupUI()
        fetchList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    override func loadView() {
        self.view = listView
    }
    
    // MARK: - Objcs
    @objc
    func navigationSettingsViewController() {
        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .formSheet
        let navigationSettingsVC = UINavigationController(rootViewController: SettingsViewController())
        self.present(navigationSettingsVC, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    private func setupUI() {
        title = "Repositories 🐙"
        searchControllerUI()
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func searchControllerUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
    }
    
    private func fetchList() {
        self.service.fetchList { items in
            let configuration = ListViewConfiguration(listItems: items)
            self.listView.updateView(with: configuration)
        }
    }
}

extension ListViewController: ListViewProtocol {
    func navigationDetail(listItens: RepositoryCellViewConfiguration) {
        let vc  = DetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
