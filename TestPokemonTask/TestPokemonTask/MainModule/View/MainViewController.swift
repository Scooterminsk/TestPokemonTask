//
//  MainViewController.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 26.10.22.
//

import UIKit

class MainViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pokemonListButton: UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.4588235294, blue: 0.5725490196, alpha: 1)
        button.setTitle("Pokemon list", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.alpha = 0.6
        button.addTarget(self, action: #selector(pokemonListButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loadFromStorageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.4588235294, blue: 0.5725490196, alpha: 1)
        button.setTitle("Offline mode", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.alpha = 0.6
        button.addTarget(self, action: #selector(loadFromStorageButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var buttonsStackView = UIStackView()
    
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.startCheckingConnection()

        setupViews()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.checkNetworkStatus()
    }
    
    private func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(logoImageView)
        
        buttonsStackView = UIStackView(arrangedSubviews: [pokemonListButton,
                                                         loadFromStorageButton],
                                       axis: .vertical,
                                       spacing: 10,
                                       distribution: .fillEqually)
        
        view.addSubview(buttonsStackView)
    }
    
    @objc func pokemonListButtonTapped() {
        presenter.toPokemons()
    }
    
    @objc func loadFromStorageButtonTapped() {
        presenter.toPokemons()
    }
}

//MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    func onlineMode() {
        pokemonListButton.isEnabled = true
        pokemonListButton.alpha = 1.0
    }
    
    func offlineMode() {
        loadFromStorageButton.isEnabled = true
        loadFromStorageButton.alpha = 1.0
    }
}

//MARK: - SetConstraints
extension MainViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            logoImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            buttonsStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 30),
            buttonsStackView.heightAnchor.constraint(equalToConstant: view.frame.width / 2 - 30)
        ])
    }
}
