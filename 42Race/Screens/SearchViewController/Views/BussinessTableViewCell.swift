//
//  BussinessTableViewCell.swift
//  42Race
//
//  Created by Anh Le on 15/01/2022.
//

import UIKit
import Kingfisher

struct BussinessTableViewCellViewModel {
    let profileUrl: URL?
    let name: String?
    let category: String?
    let operation: String?
    let operationTextColor: UIColor
    let address: String?
    let phone: String?
    let rating: String?
    
    init(bussiness: Bussiness) {
        self.profileUrl = URL(string: bussiness.imageURLString ?? "")
        self.name = bussiness.name
        self.category = bussiness.categories.joined(separator: ", ")
        self.operation = bussiness.isClosed ? "Closed" : "Opened"
        self.operationTextColor = bussiness.isClosed ? .red : .green
        self.address = bussiness.displayAddress.joined(separator: ", ")
        self.phone = bussiness.phone
        if let rating = bussiness.rating {
            self.rating = String(rating)
        } else {
            self.rating = "--"
        }
    }
}

class BussinessTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var operationLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    var viewModel: BussinessTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            configureWith(viewModel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    private func configureView() {
        selectionStyle = .none
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        operationLabel.font = .italicSystemFont(ofSize: 14)
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .lightGray
        phoneLabel.font = .systemFont(ofSize: 14,weight: .bold)
        ratingLabel.font = .systemFont(ofSize: 16)
        ratingLabel.textColor = .orange
    }
    
    private func configureWith(_ viewModel: BussinessTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        categoriesLabel.text = viewModel.category
        operationLabel.text = viewModel.operation
        operationLabel.textColor = viewModel.operationTextColor
        addressLabel.text = viewModel.address
        phoneLabel.text = viewModel.phone
        ratingLabel.text = viewModel.rating
        profileImageView.kf.setImage(with: viewModel.profileUrl, placeholder: nil, options: [.fromMemoryCacheOrRefresh], completionHandler: nil)
    }
}
