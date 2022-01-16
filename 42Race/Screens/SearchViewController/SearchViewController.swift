//
//  SearchViewController.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MBProgressHUD

class SearchViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: SearchViewModel!
    
    class func create(with viewModel: SearchViewModel) -> SearchViewController {
        let vc = SearchViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!ß
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defer { viewModel.viewDidLoad.accept(()) }
        configureView()
        bind(to: viewModel)
    }
    
    // MARK: - Privates
    private let disposeBag = DisposeBag()
    typealias Section = SectionModel<String, BussinessTableViewCellViewModel>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    private lazy var dataSource = makeDataSource()
    
    private func bind(to viewModel: SearchViewModel) {
        // Inputs
        searchBar.rx.textDidEndEditing.bind(to: viewModel.searchRelay).disposed(by: disposeBag)
        searchBar.rx.text.compactMap { $0 ?? "" }.bind(to: viewModel.searchText).disposed(by: disposeBag)
        
        // Outputs
        viewModel.bussinessRelay
            .map { businesses -> [Section] in
                let models = businesses.map { BussinessTableViewCellViewModel(bussiness: $0) }
                return [Section(model: "", items: models)]
            }.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.filterTypeRelay.subscribe(onNext: { [weak self] type in
            self?.updateSearchBar(searchType: type)
        }).disposed(by: disposeBag)
        
        viewModel.isLoadingRelay
            .subscribe(onNext: { [weak self] isLoading in
                guard let view = self?.view else { return }
                if isLoading {
                    MBProgressHUD.showAdded(to: view, animated: true)
                } else {
                    MBProgressHUD.hide(for: view, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureView() {
        title = "Yelp Sample"
        let filterButton = UIBarButtonItem(image: Images.ic_filter_advance,
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(filterDidTap))
        let sortingButton = UIBarButtonItem(image: Images.ic_filter_listing,
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(filterDidTap))
        let rightItems: [UIBarButtonItem] = [sortingButton, filterButton]
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
        
        tableView.register(cellType: BussinessTableViewCell.self)
        
        addDoneButtonOnKeyboard()
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource { _, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BussinessTableViewCell.self)
            cell.viewModel = model
            return cell
        }
    }
    
    @objc private func filterDidTap() {
        viewModel.openFilter.accept(())
    }
    
    @objc private func sortingDidTap() {
        viewModel.openFilter.accept(())
    }
    
    private func updateSearchBar(searchType: SearchFilterType) {
        switch searchType {
            case .term:
                searchBar.placeholder = "Enter term. Ex: 'Spaghetti'"
            case .address:
                searchBar.placeholder = "Enter address. Ex: 'NYC'"
            case .phone:
                searchBar.keyboardType = .phonePad
                searchBar.placeholder = "Enter phone. Ex: '+14156386361'"
        }
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        searchBar.inputAccessoryView = doneToolbar
    }

    @objc private func doneButtonAction(){
        searchBar.endEditing(true)
    }
}
