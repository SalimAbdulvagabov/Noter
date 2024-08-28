//
//  SiriCommandsHeaderView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class SiriCommandsHeaderView: UIView {

    // MARK: - Private: properties

    private let imageView = UIImageView(image: Images.shortcuts()).then {
        $0.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
    }
    private let descriptionLabel = UILabel().then {
        $0.text = Localized.siriDescription()
        $0.setLineSpacing(spacing: 1.07)
        $0.font = Fonts.interMedium(size: 14)
        $0.textColor = Colors.tokyo()
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    private let addShortcutLabel = UILabel().then {
        $0.text = Localized.addShortcut()
        $0.textAlignment = .left
        $0.font = Fonts.interMedium(size: 16)
        $0.textColor = Colors.monaco()
    }
    private let separatorView = UIView().then {
        $0.backgroundColor = Colors.paris()
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private: funcs

    private func setupViews() {
        backgroundColor = Colors.london()

        addSubviews([
            imageView,
            descriptionLabel,
            addShortcutLabel,
            separatorView
        ])

        imageView.autoSetDimensions(to: .init(width: 40, height: 40))
        imageView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)

        descriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        descriptionLabel.autoPinEdge(.left, to: .right, of: imageView, withOffset: 16)

        imageView.autoAlignAxis(.horizontal, toSameAxisOf: descriptionLabel)

        separatorView.autoSetDimension(.height, toSize: 12)
        separatorView.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: 24)
        separatorView.autoPinEdge(toSuperviewEdge: .left)
        separatorView.autoPinEdge(toSuperviewEdge: .right)

        addShortcutLabel.autoPinEdge(.top, to: .bottom, of: separatorView, withOffset: 20)
        addShortcutLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        addShortcutLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        addShortcutLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
    }
}
