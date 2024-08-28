//
//  SettingsCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.10.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class SettingsCell: ScalledTableViewCell {

    private lazy var iconImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView =  UIImageView(image: Images.arrowRightIcon())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.text()
        label.font = Fonts.interMedium(size: 16)
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator()
        return view
    }()

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
        [iconImageView, nameLabel, arrowImageView].forEach {
            addSubview($0)
        }

        iconImageView.autoSetDimensions(to: CGSize(width: imageSize, height: imageSize))
        iconImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 12,
                                                                      left: 20,
                                                                      bottom: 12,
                                                                      right: 0), excludingEdge: .right)

        nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: iconImageView)
        nameLabel.autoPinEdge(.left, to: .right, of: iconImageView, withOffset: 16)

        arrowImageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        arrowImageView.autoAlignAxis(.horizontal, toSameAxisOf: iconImageView)
        arrowImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        addSubview(separatorView)
        separatorView.autoPinEdge(toSuperviewEdge: .bottom)
        separatorView.autoPinEdge(.left, to: .left, of: nameLabel)
        separatorView.autoPinEdge(.right, to: .right, of: arrowImageView)
        separatorView.autoSetDimension(.height, toSize: 1)
    }

}

extension SettingsCell: Configurable {
    struct Model {
        let icon: UIImage?
        let name: String
        let showBottomSeparator: Bool
    }

    func configure(with model: Model) {
        nameLabel.text = model.name
        iconImageView.image = model.icon
        separatorView.isHidden = !model.showBottomSeparator
    }
}

private let imageSize: CGFloat = 32
