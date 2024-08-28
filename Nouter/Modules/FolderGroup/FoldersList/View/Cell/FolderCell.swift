//
//  FolderCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 15.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class FolderCell: UITableViewCell {

    private let iconImageView = UIImageView(image: Images.folderIcon()).then {
        $0.contentMode = .scaleAspectFit
    }

    private let nameLabel = UILabel().then {
        $0.textColor = Colors.text()
        $0.numberOfLines = 1
        $0.font = Fonts.interMedium(size: 16)
    }

    private let countLabel = UILabel().then {
        $0.font = Fonts.interMedium(size: 16)
        $0.numberOfLines = 1
        $0.textColor = Colors.loading()
    }

    private let checkedImageView = UIImageView(image: Images.checkedIcon()).then {
        $0.contentMode = .scaleAspectFit
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = Colors.separator()
    }

    var isChecked: Bool = false {
        didSet {
            checkedImageView.isHidden = !isChecked
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = Colors.screenBackground()
        contentView.addSubviews([
            iconImageView,
            nameLabel,
            countLabel,
            checkedImageView,
            separatorView
        ])

        iconImageView.autoSetDimensions(to: .init(width: 32, height: 32))
        iconImageView.autoPinEdgesToSuperviewEdges(with: .init(top: verticalOffset,
                                                               left: horizontalOffset,
                                                               bottom: verticalOffset, right: 0),
                                                   excludingEdge: .right)

        nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: iconImageView)
        nameLabel.autoPinEdge(.left, to: .right, of: iconImageView, withOffset: verticalOffset)

        countLabel.autoAlignAxis(.horizontal, toSameAxisOf: nameLabel)
        countLabel.autoPinEdge(.left, to: .right, of: nameLabel, withOffset: 6)

        checkedImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        checkedImageView.autoPinEdge(toSuperviewEdge: .right, withInset: horizontalOffset)

        separatorView.autoPinEdge(.left, to: .left, of: nameLabel)
        separatorView.autoPinEdge(toSuperviewEdge: .bottom)
        separatorView.autoPinEdge(toSuperviewEdge: .right, withInset: horizontalOffset)
        separatorView.autoSetDimension(.height, toSize: 1)
    }

}

extension FolderCell: Configurable {
    struct Model {
        let name: String
        let count: Int
        let checked: Bool
    }

    func configure(with model: Model) {
        nameLabel.text = model.name

        countLabel.isHidden = model.count == 0
        countLabel.text = String(model.count)

        checkedImageView.isHidden = !model.checked
    }
}

private let verticalOffset: CGFloat = 12
private let horizontalOffset: CGFloat = 20
