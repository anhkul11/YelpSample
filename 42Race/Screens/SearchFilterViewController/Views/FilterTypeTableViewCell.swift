//
//  FilterTypeTableViewCell.swift
//  42Race
//
//  Created by Anh Le on 16/01/2022.
//

import UIKit
struct FilterTypeTableCellViewModel {
    let typeText: String?
    let isSelected: Bool
    init(filterType: SearchFilterType, isSelected: Bool) {
        switch filterType {
            case .term:
                typeText = "Term"
            case .address:
                typeText = "Address"
            case .phone:
                typeText = "Phone"
        }
        self.isSelected = isSelected
    }
}

class FilterTypeTableViewCell: UITableViewCell, NibReusable {

    var viewModel: FilterTypeTableCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            configureWith(viewModel)
        }
    }
    
    @IBOutlet private weak var isSelectedImageView: UIImageView!
    @IBOutlet private weak var searchTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSelectedImageView.image = Images.ic_selected
        selectionStyle = .none
    }
    
    private func configureWith(_ viewModel: FilterTypeTableCellViewModel) {
        isSelectedImageView.isHidden = !viewModel.isSelected
        searchTypeLabel.text = viewModel.typeText
    }
}
