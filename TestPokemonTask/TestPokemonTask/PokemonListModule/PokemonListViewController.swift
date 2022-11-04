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
        title = "Pokemons"
        
        view.addSubview(pokemonNamesTableView)
    }
    
    private func setupDelegates() {
        pokemonNamesTableView.dataSource = self
        pokemonNamesTableView.delegate = self
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 70))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }


}

//MARK: - UITableViewDataSource
extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.pokemons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonNameCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let pokemon = presenter.pokemons?[indexPath.row]
        cell.accessoryView = UIImageView(image: R.image.pokeball())
        content.text = pokemon?.name.capitalized
        cell.contentConfiguration = content
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = presenter.pokemons?[indexPath.row]
        presenter.tapOnPokemonsName(pokemon: pokemon, id: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > pokemonNamesTableView.contentSize.height - 70 - scrollView.frame.size.height
            && presenter.pokemons?.count ?? 0 < 20 {
            self.pokemonNamesTableView.tableFooterView = createSpinnerFooter()
            presenter.getPokemonsPagination()
            self.pokemonNamesTableView.tableFooterView = nil
        }
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

