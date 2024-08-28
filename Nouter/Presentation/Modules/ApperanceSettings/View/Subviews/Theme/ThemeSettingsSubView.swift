//
//  ThemeSettingsSubView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 10.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol ThemeSettingsSubViewDelegate: AnyObject {
    func themeSelect(type: ThemeType)
}

final class ThemeSettingsSubView: ScalledView {

    private lazy var imageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.cornerRadius = imageSide/2
        imageView.borderWidth = 1
        return imageView
    }()

    private lazy var textLabel: CorneredLabel = {
        let label = CorneredLabel()
        label.font = Fonts.interMedium(size: 14)
        label.textAligment = .center
        label.textColor = Colors.text()
        return label
    }()

    private lazy var selectView: UIView = {
        let view = UIView()
        view.cornerRadius = selectSide/2
        view.borderWidth = 3
        view.borderColor = .clear
        return view
    }()

    var type: ThemeType?

    var isSelect: Bool = false {
        didSet {
            setSelect()
        }
    }

    init(type: ThemeType) {
        super.init(frame: .zero)
        self.type = type
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.selectView.borderColor = self.isSelect ? Colors.screenBackgroundInversion() : .clear
        self.imageView.borderColor = type?.borderColor
    }

    private func setupUI() {
        addSubview(selectView)
        addSubview(imageView)
        addSubview(textLabel)

        selectView.autoSetDimensions(to: .init(width: selectSide, height: selectSide))
        selectView.autoPinEdge(toSuperviewEdge: .top)
        selectView.autoAlignAxis(toSuperviewAxis: .vertical)

        imageView.autoSetDimensions(to: .init(width: imageSide, height: imageSide))
        imageView.autoAlignAxis(.horizontal, toSameAxisOf: selectView)
        imageView.autoAlignAxis(.vertical, toSameAxisOf: selectView)

        textLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 12)
        textLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        textLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 12, relation: .greaterThanOrEqual)
        textLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 12, relation: .greaterThanOrEqual)

        guard let type = type else { return }
        textLabel.text = type.text
        imageView.image = type.image
        imageView.backgroundColor = type.backgroundColor
        imageView.borderColor = type.borderColor
    }

    private func setSelect() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.selectView.borderColor = self.isSelect ? Colors.screenBackgroundInversion() : .clear
            self.textLabel.backgroundColor = self.isSelect ? Colors.screenBackgroundInversion() : .clear
            self.textLabel.textColor = self.isSelect ?
                Colors.screenBackground() :
                Colors.screenBackgroundInversion()
        }
    }

}

private let selectSide: CGFloat = 44
private let imageSide: CGFloat = 32
