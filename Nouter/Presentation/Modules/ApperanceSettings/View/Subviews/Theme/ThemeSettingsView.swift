//
//  ThemeSettingsView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 10.03.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeSettingsViewDelegate: AnyObject {
    func selectTheme(theme: ThemeType)
}

final class ThemeSettingsView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тема"
        label.textAlignment = .left
        label.font = Fonts.interMedium(size: 16)
        label.textColor = Colors.loading()
        return label
    }()

    private lazy var stackView = UIStackView(axis: .horizontal,
                                             alignment: .fill,
                                             distribution: .equalCentering)

    weak var delegate: ThemeSettingsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(stackView)
        titleLabel.autoPinEdgesToSuperviewEdges(excludingEdge: .bottom)
        stackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 24)
        stackView.autoAlignAxis(toSuperviewAxis: .vertical)
        stackView.autoPinEdge(toSuperviewEdge: .bottom)
        let systemTheme = ThemeSettingsSubView(type: .system)
        systemTheme.addTapGestureRecognizer {
            self.themeSelect(type: .system)
        }
        let lightTheme = ThemeSettingsSubView(type: .light)
        lightTheme.addTapGestureRecognizer {
            self.themeSelect(type: .light)
        }
        let darkTheme = ThemeSettingsSubView(type: .dark)
        darkTheme.addTapGestureRecognizer {
            self.themeSelect(type: .dark)
        }
        stackView.addArrangedSubviews([systemTheme,
                                       lightTheme,
                                       darkTheme
        ])
    }

    func themeSelect(type: ThemeType) {
        delegate?.selectTheme(theme: type)
        stackView.arrangedSubviews.forEach {
            let subView = $0 as? ThemeSettingsSubView
            subView?.isSelect = subView?.type == type
        }
    }

}
