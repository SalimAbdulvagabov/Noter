//
//  ArrowCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

final class ArrowCell: ScalledTableViewCell {

    // MARK: - Properties

    private var arrowImageView = UIImageView(image: Images.arrowRightIcon())
    private var separatorView = UIView().then {
        $0.backgroundColor = Colors.berlin()
    }
    private var label = UILabel().then {
        $0.textColor = Colors.tokyo()
        $0.font = Fonts.interMedium(size: 16)
        $0.numberOfLines = 1
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = Colors.london()

        addSubviews([
            label,
            arrowImageView,
            separatorView
        ])

        label.autoPinEdgesToSuperviewEdges(with: .init(top: 18.5,
                                                       left: 20,
                                                       bottom: 19.5,
                                                       right: 52),
                                           excludingEdge: .right)

        arrowImageView.autoSetDimensions(to: .init(width: 20, height: 20))
        arrowImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        arrowImageView.autoAlignAxis(.horizontal, toSameAxisOf: label)

        separatorView.autoSetDimension(.height, toSize: 1)
        separatorView.autoPinEdgesToSuperviewEdges(with: .init(horizontal: 20), excludingEdge: .top)
    }

}

// MARK: - Configurable

extension ArrowCell: Configurable {
    struct Model {
        let text: String
        let hasSeparator: Bool
    }

    func configure(with model: Model) {
        label.text = model.text
        separatorView.isHidden = !model.hasSeparator
    }
}
