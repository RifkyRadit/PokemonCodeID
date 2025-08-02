//
//  DetailPokemonViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import UIKit
import MBProgressHUD
import RxSwift

class DetailPokemonViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var abilityCollectionView: UICollectionView!
    
    private(set) var viewModel = DetailPokemonViewModel()
    private let disposeBag = DisposeBag()
    
    var pokemoneName = ""
    private var abilityList = [AbilitiesModel]()
    private var viewState: DetailViewState = .loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.viewDidLoad(pokemonName: self.pokemoneName)
        self.title = pokemoneName.capitalized
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBackButton()
        self.navigationController?.isNavigationBarHidden = false
    }

    private func bindViewModel() {
        viewModel.outputs.state
            .subscribe(onNext: { [weak self] resultState in
                guard let self, let state = resultState else { return }
                self.viewState = state
                self.configureState(state)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 8
        
        abilityCollectionView.register(UINib(nibName: "AbilityItemCell", bundle: nil), forCellWithReuseIdentifier: "abilityItemCell")
        abilityCollectionView.register(UINib(nibName: "AbilityErrorCell", bundle: nil), forCellWithReuseIdentifier: "abilityErrorCell")
        abilityCollectionView.delegate = self
        abilityCollectionView.dataSource = self
        abilityCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        abilityCollectionView.collectionViewLayout = flowLayout
        abilityCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.abilityCollectionView.reloadData()
        }
    }
}

// MARK: - Configure View
extension DetailPokemonViewController {
    private func configureState(_ state: DetailViewState) {
        switch state {
        case .loading:
            containerView.isHidden = true
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading...."
            
        case .showContent(let dataPokemon):
            containerView.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
            abilityList = dataPokemon
            reloadData()
        case .failure:
            MBProgressHUD.hide(for: self.view, animated: true)
            containerView.isHidden = false
            reloadData()
        }
        
        pokemonNameLabel.text = self.pokemoneName.uppercased()
    }
    
    private func configureBackButton() {
        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_back"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        button.tintColor = .black
        
        backView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: backView.topAnchor),
            button.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DetailPokemonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewState {
        case .loading:
            return 0
        case .failure:
            return 1
        case .showContent:
            return abilityList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewState {
        case .loading:
            return UICollectionViewCell()
        case .failure(let errorState):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "abilityErrorCell", for: indexPath) as? AbilityErrorCell else {
                return UICollectionViewCell()
            }
            
            cell.configureContentCell(state: errorState)
            cell.errorView.delegate = self
            return cell
            
        case .showContent:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "abilityItemCell", for: indexPath) as? AbilityItemCell else {
                return UICollectionViewCell()
            }
            
            cell.configureContentCell(ability: abilityList[indexPath.row].ability)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let totalSpacing = spacing * 3
        let width: CGFloat = (collectionView.bounds.width - totalSpacing) / 2
        
        switch viewState {
        case .failure, .loading:
            return CGSize(width: collectionView.bounds.width, height: self.view.bounds.height / 2)
        case .showContent:
            return CGSize(width: width, height: 36)
        }
    }
}

// MARK: - ErrorStateViewDelegate
extension DetailPokemonViewController: ErrorStateViewDelegate {
    func didTapRetryButton() {
        viewModel.viewDidLoad(pokemonName: self.pokemoneName)
    }
}
