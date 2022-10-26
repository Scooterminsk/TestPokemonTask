//
//  DetailViewController.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

class DetailViewController: UIViewController {

    private let pokemonImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let typesLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Pokemon's types are: test, test, test"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Pokemon's weight is 10 kg"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
         label.font = .systemFont(ofSize: 18)
         label.textAlignment = .center
         label.text = "Pokemon's height is 150 cm"
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
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
        
        view.addSubview(pokemonImageView)
        parametersStackView = UIStackView(arrangedSubviews: [typesLabel,
                                                            weightLabel,
                                                            heightLabel],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillProportionally)
        view.addSubview(parametersStackView)
        
    }
}

extension DetailViewController: DetailViewProtocol {
    func pokemonDescriptionSuccess() {
        if let height = presenter.pokemonDescription?.height,
           let weight = presenter.pokemonDescription?.weight {
            heightLabel.text = String(height)
            weightLabel.text = String(weight)
        }
    }
    
    func pokemonDescriptionFailure(error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - SetConstraints
extension DetailViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            pokemonImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            pokemonImageView.heightAnchor.constraint(equalToConstant: view.frame.width - 20),
            
            parametersStackView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            parametersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parametersStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 20)
        ])
    }
}
