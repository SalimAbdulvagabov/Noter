//
//  ChangeIconAppCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class ChangeIconAppCell: ScalledCollectionViewCell {

    private lazy var selectView: UIView = {
        let view = UIView()
        view.cornerRadius = 18
        view.layer.cornerCurve = .continuous
        view.borderWidth = 3
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.cornerRadius = 12
        imageView.borderWidth = 1
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        return imageView
    }()

    private var type: AppIconType!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selectView.borderColor = Colors.screenBackgroundInversion()
        imageView.borderColor = type.borderColor
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(selectView)
        selectView.autoPinEdgesToSuperviewEdges()
        imageView.autoPinEdgesToSuperviewEdges(with: .init(top: 6,
                                                           left: 6,
                                                           bottom: 6,
                                                           right: 6))
    }
}

extension ChangeIconAppCell: Configurable {
    struct Model {
        let type: AppIconType
        let selected: Bool
    }

    func configure(with model: Model) {
        type = model.type
        imageView.image = model.type.preview
        selectView.isHidden = !model.selected
        imageView.borderColor = model.type.borderColor
        selectView.borderColor = Colors.screenBackgroundInversion()
    }
}
