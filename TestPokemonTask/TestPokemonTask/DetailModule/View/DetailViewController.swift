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
        imageView.image = UIImage(named: "backgroundDetail")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let pokemonImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "unknown")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
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
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 18)
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private var nameAndLineStackView = UIStackView()
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
        
        parametersStackView = UIStackView(arrangedSubviews: [typesLabel,
                                                             weightLabel,
                                                             heightLabel],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillProportionally)
        
        view.addSubview(nameAndLineStackView)
        view.addSubview(parametersStackView)
    }
}

//MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    
    func setPokemonImage(imageData: Data?) {
        guard let data = imageData else {
            pokemonImageView.image = UIImage(named: "unknown")
            return
        }
        pokemonImageView.image = UIImage(data: data)
        presenter.dbManager?.updatePokemonsImage(id: presenter.id, imageData: data)
    }
    
    func pokemonDescriptionSuccess() {
        nameLabel.text = presenter.pokemon?.name.capitalized
        if let height = presenter.pokemonDescription?.height,
           let weight = presenter.pokemonDescription?.weight,
           let types = presenter.pokemonDescription?.types {
            // Because default height is in decimetres, default weight is in hectograms, according to API documentation
            heightLabel.text = "Height: " + String(height * 10) + " cm"
            weightLabel.text = "Weight: " + String(Double(weight) / 10.0) + " kg"
            typesLabel.text = "Type: " + types.map{$0.type.name.capitalized}.joined(separator: ", ")
        }
    }
    
    func pokemonDescriptionSuccessRealm(name: String, height: Int, weight: Int, types: String) {
        nameLabel.text = name.capitalized
        heightLabel.text = "Height: " + String(height * 10) + " cm"
        weightLabel.text = "Weight: " + String(Double(weight) / 10.0) + " kg"
        typesLabel.text = "Type: " + types
    }
    
    func pokemonDescriptionFailure(error: Error) {
        print(error.localizedDescription)
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
            
            
            parametersStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            parametersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parametersStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 20)
        ])
    }
}
