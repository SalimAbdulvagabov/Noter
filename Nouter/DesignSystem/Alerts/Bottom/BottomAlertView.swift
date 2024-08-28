//
//  BottomAlertView.swift
//  DesignSystem
//
//  Created by Салим Абдулвагабов on 11.02.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import VisualEffectView

public protocol IBottomAlertView: UIView {
    func configure(with model: BottomAlertModel)
}

public protocol BottomAlertViewDelegate: AnyObject {
    func buttonClick(from alertView: IBottomAlertView)
}

final class BottomAlertView: UIView {

    // MARK: - Private properties

    private weak var delegate: BottomAlertViewDelegate?
    private var viewModel: BottomAlertViewModel

    // MARK: - Views

    private lazy var button = BaseButton().then { button in
        button.setTitleColor(Colors.blue(), for: .normal)
        button.font = Fonts.interSemiBold(size: 14)
        button.addAction { [unowned self] in
            self.delegate?.buttonClick(from: self)
        }
    }

    private let textLabel = UILabel().then { label in
        label.textColor = Colors.text()
        label.font = Fonts.interRegular(size: 14)
    }

    private let stackView = UIStackView().then { stackView in
        stackView.alignment = .fill
        stackView.spacing = 16
    }

    private let blurView = VisualEffectView().then { blurView in
        blurView.colorTint = Colors.deleteView()
        blurView.colorTintAlpha = 0.6
        blurView.blurRadius = 6
        blurView.scale = 1
    }

    // MARK: - Init

    init(viewModel: BottomAlertViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal funcs

    func updateViewModel(_ viewModel: BottomAlertViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Private funcs

    private func commonInit() {
        stackView.addArrangedSubviews([
            button,
            textLabel
        ])

        addSubviews([
            blurView,
            stackView
        ])

        blurView.autoPinEdgesToSuperviewEdges()
        stackView.autoPinEdgesToSuperviewEdges(with: .init(horizontal: 20))
    }
}

// MARK: - IBottomNotificationView

extension BottomAlertView: IBottomAlertView {
    func configure(with model: BottomAlertModel) {
        self.delegate = model.delegate
    }

}
