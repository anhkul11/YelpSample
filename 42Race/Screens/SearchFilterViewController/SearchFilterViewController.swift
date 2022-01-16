//
//  SearchFilterViewController.swift
//  42Race
//
//  Created by Anh Le on 16/01/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchFilterViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: SearchFilterViewModel!
    
    class func create(with viewModel: SearchFilterViewModel) -> SearchFilterViewController {
        let vc = SearchFilterViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Privates
    private let disposeBag = DisposeBag()
    typealias Section = SectionModel<String, FilterTypeTableCellViewModel>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: SearchFilterViewModel) {
        Observable.combineLatest(viewModel.selectedType.asObservable(),
                                 viewModel.searchTypes.asObservable())
            .map { (selectedType, types) -> [Section] in
                let models = types.map { FilterTypeTableCellViewModel(filterType: $0, isSelected: $0 == selectedType) }
                return [Section(model: "", items: models)]
            }.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.map { $0.row }
        .compactMap { [weak self] row in
            return self?.viewModel.searchTypes.value[row]
        }
        .subscribe(onNext: { [weak self] type in
            self?.dismiss(animated: true, completion: nil)
            self?.viewModel.didSelect(type: type)
        }).disposed(by: disposeBag)
    }
    
    private func configureView() {
        tableView.separatorStyle = .singleLine
        tableView.register(cellType: FilterTypeTableViewCell.self)
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource { _, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FilterTypeTableViewCell.self)
            cell.viewModel = model
            return cell
        }
    }
}
