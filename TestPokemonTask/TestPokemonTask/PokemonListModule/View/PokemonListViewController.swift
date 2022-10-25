//
//  PokemonListViewController.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    private let pokemonNamesTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokemonNameCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var presenter: PokemonListPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegates()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(pokemonNamesTableView)
    }
    
    private func setupDelegates() {
        pokemonNamesTableView.dataSource = self
        pokemonNamesTableView.delegate = self
    }


}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.pokemons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonNameCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let pokemon = presenter.pokemons?[indexPath.row]
        content.text = pokemon?.name
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - PokemonListViewProtocol
extension PokemonListViewController: PokemonListViewProtocol {
    func success() {
        pokemonNamesTableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - SetConstraints
extension PokemonListViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pokemonNamesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            pokemonNamesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pokemonNamesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pokemonNamesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

