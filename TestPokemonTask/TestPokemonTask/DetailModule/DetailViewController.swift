//
//  DetailViewController.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

class DetailViewController: UIViewController {

    private let topImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = R.image.backgroundDetail()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pokemonImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = R.image.unknown()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Pokemon not saved"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let greenLineImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "greenLine")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let hpLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = "HP 100/100"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typesLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.text = "TYPE"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typesDescriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.text = "WEIGHT"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightDescriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.text = "HEIGHT"
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightDescriptionLabel: UILabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 18)
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let pokeballImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = R.image.pokeball()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameAndLineStackView = UIStackView()
    private var typesStackView = UIStackView()
    private var weightStackView = UIStackView()
    private var heightStackView = UIStackView()
    private var parametersStackView = UIStackView()
    
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getPokemonDescription()

        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(topImageView)
        view.addSubview(pokemonImageView)
        
        nameAndLineStackView = UIStackView(arrangedSubviews: [nameLabel,
                                                             greenLineImageView,
                                                             hpLabel],
                                           axis: .vertical,
                                           spacing: 10,
                                           distribution: .fillProportionally)
        
        weightStackView = UIStackView(arrangedSubviews: [weightDescriptionLabel,
                                                         weightLabel],
                                       axis: .vertical,
                                       spacing: 5,
                                       distribution: .fillProportionally)
        
        typesStackView = UIStackView(arrangedSubviews: [typesDescriptionLabel,
                                                       typesLabel],
                                     axis: .vertical,
                                     spacing: 5,
                                     distribution: .fillProportionally)
        
        heightStackView = UIStackView(arrangedSubviews: [heightDescriptionLabel,
                                                         heightLabel],
                                       axis: .vertical,
                                       spacing: 5,
                                       distribution: .fillProportionally)
        
        parametersStackView = UIStackView(arrangedSubviews: [weightStackView,
                                                             typesStackView,
                                                             heightStackView],
                                          axis: .horizontal,
                                          spacing: 10,
                                          distribution: .fillEqually)
        
        view.addSubview(nameAndLineStackView)
        view.addSubview(parametersStackView)
        view.addSubview(pokeballImageView)
    }
}

//MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    
    func setPokemonImage(imageData: Data?) {
        guard let data = imageData else {
            pokemonImageView.image = R.image.unknown()
            return
        }
        DispatchQueue.main.async {
            self.pokemonImageView.image = UIImage(data: data)
            self.presenter.dbManager?.updatePokemonsImage(id: self.presenter.id, imageData: data)
        }
    }
    
    func pokemonDescriptionSuccess() {
        nameLabel.text = presenter.pokemon?.name.capitalized
        if let height = presenter.pokemonDescription?.height,
           let weight = presenter.pokemonDescription?.weight,
           let types = presenter.pokemonDescription?.types {
            // Because default height is in decimetres, default weight is in hectograms, according to API documentation
            heightDescriptionLabel.text = String(height * 10) + " cm"
            weightDescriptionLabel.text = String(Double(weight) / 10.0) + " kg"
            typesDescriptionLabel.text = types.map{$0.type.name.capitalized}.joined(separator: " / ")
        }
    }
    
    func pokemonDescriptionSuccessRealm(name: String, height: Int, weight: Int, types: String) {
        nameLabel.text = name.capitalized
        heightDescriptionLabel.text = String(height * 10) + " cm"
        weightDescriptionLabel.text = String(Double(weight) / 10.0) + " kg"
        typesDescriptionLabel.text = types
    }
    
    func pokemonDescriptionFailure(error: Error) {
        Log.error(error.localizedDescription, shouldLogContext: true)
    }
}

//MARK: - SetConstraints
extension DetailViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 20),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: 350),
            
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: topImageView.topAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            pokemonImageView.heightAnchor.constraint(equalToConstant: view.frame.width - 20),
            
            nameAndLineStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameAndLineStackView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            nameAndLineStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            
            parametersStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: view.frame.width / 4),
            parametersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parametersStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            
            pokeballImageView.topAnchor.constraint(equalTo: parametersStackView.bottomAnchor, constant: 20),
            pokeballImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokeballImageView.widthAnchor.constraint(equalToConstant: 30),
            pokeballImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
