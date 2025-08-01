//
//  HomepageViewController.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 31/07/25.
//

import UIKit
import XLPagerTabStrip
import MBProgressHUD
import RxSwift

class HomepageViewController: UIViewController, IndicatorInfoProvider {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    private(set) var viewModel = HomepageViewModel()
    private let disposeBag = DisposeBag()
    
    private var refreshControl = UIRefreshControl()
    private var pokemonDataList = [PokemonListModelData]()
    private var filterList = [PokemonListModelData]()
    private var isSearchActive = false
    
    private var offset = 0
    private var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        bindViewModel()
        viewModel.viewDidLoad(offset: offset)
    }
    
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "HomePage")
    }
    
    private func setupView() {
        viewSearch.layer.cornerRadius = 8
        viewSearch.layer.borderColor = UIColor(named: "color_gray")?.cgColor
        viewSearch.layer.borderWidth = 2
        viewSearch.layer.masksToBounds = true
        
        searchButton.backgroundColor = UIColor(named: "color_main_red")
        searchButton.layer.cornerRadius = 8
        searchButton.layer.masksToBounds = true
        
        searchTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        refreshControl.addTarget(self, action: #selector(pullToRefreshList), for: .valueChanged)
        
        errorView.isHidden = true
        errorView.delegate = self
    }
    
    private func setupTableView() {
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
        pokemonTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        pokemonTableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "pokemonCell")
        pokemonTableView.register(UINib(nibName: "EmptyCell", bundle: nil), forCellReuseIdentifier: "emptyCell")
        pokemonTableView.rowHeight = UITableView.automaticDimension
        pokemonTableView.refreshControl = refreshControl
        pokemonTableView.separatorStyle = isSearchActive && filterList.isEmpty ? .none : .singleLine
    }
    
    private func bindViewModel() {
        viewModel.outputs.state
            .subscribe(onNext: { [weak self] resultState in
                guard let self, let state = resultState else { return }
                self.configureState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureState(_ state: HomepageViewState) {
        refreshControl.endRefreshing()
        switch state {
        case .loading:
            errorView.isHidden = true
            contentView.isHidden = !isLoadingMore
            
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = "Loading...."
            
        case .error:
            MBProgressHUD.hide(for: self.view, animated: true)
            
            errorView.isHidden = false
            contentView.isHidden = true
            errorView.configureContent(with: .generalError)
            
        case .empty:
            MBProgressHUD.hide(for: self.view, animated: true)
            
            errorView.isHidden = false
            contentView.isHidden = true
            errorView.configureContent(with: .emptyPokemonList)
            
        case .showContent(let dataList):
            MBProgressHUD.hide(for: self.view, animated: true)
            
            errorView.isHidden = true
            contentView.isHidden = false
            
            if isLoadingMore {
                pokemonDataList.append(contentsOf: dataList)
                isLoadingMore = false
            } else {
                pokemonDataList = dataList
            }
            
            reloadData()
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.pokemonTableView.reloadData()
        }
    }
    
    @objc private func pullToRefreshList() {
        refreshControl.beginRefreshing()
        offset = 0
        isLoadingMore = false
        viewModel.viewDidLoad(offset: offset)
    }
    
    @objc private func textFieldsDidChange() {
        if let searchText = searchTextField.text, searchText.isEmpty {
            isSearchActive = false
            reloadData()
        }
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        searchTextField.resignFirstResponder()
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            isSearchActive = false
            reloadData()
            return
        }
        
        isSearchActive = true
        
        let textFieldText = searchTextField.text ?? ""
        let filterList = pokemonDataList.filter({ $0.name.lowercased().contains(textFieldText) })
        self.filterList = filterList
        reloadData()
    }
    
}

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return filterList.isEmpty ? 1 : filterList.count
        } else {
            return pokemonDataList.isEmpty ? 1 : pokemonDataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearchActive, filterList.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? EmptyCell else {
                return UITableViewCell()
            }
            
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            cell.configureContentCell()
            cell.errorView.delegate = self
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as? PokemonCell else {
                return UITableViewCell()
            }
            
            let sourceList = isSearchActive ? filterList : pokemonDataList
            guard !sourceList.isEmpty else { return UITableViewCell() }
            
            tableView.separatorStyle = .singleLine
            cell.selectionStyle = .none
            cell.configureContentCell(pokemonName: sourceList[indexPath.row].name)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sourceList = isSearchActive ? filterList : pokemonDataList
        guard !sourceList.isEmpty else { return }
        
        let selectedPokemonName = sourceList[indexPath.row].name
        
        let detailVC = DetailPokemonViewController()
        detailVC.pokemoneName = selectedPokemonName
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if position >= (contentHeight - frameHeight + 50), !isLoadingMore, !isSearchActive {
            isLoadingMore = true
            offset += 10
            viewModel.viewDidLoad(offset: offset)
        }
    }
}

extension HomepageViewController: ErrorStateViewDelegate {
    func didTapRetryButton() {
        offset = 0
        isLoadingMore = false
        viewModel.viewDidLoad(offset: offset)
    }
}
