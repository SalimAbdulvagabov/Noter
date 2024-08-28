//
//  NotificationsDisabledView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 22.01.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationsDisabledViewDelegate: AnyObject {
    func openSettingsButtonClick()
}

final class NotificationsDisabledView: UIView {

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.backgroundColor = Colors.buttonBackground()
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.openSettings()
        label.setTextWithLineSpacing(text: Localized.notificationsDisabledDescription(), spacing: 1.07)
        label.numberOfLines = 3
        label.textColor = Colors.text()
        label.font = Fonts.interMedium(size: 14)
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: Images.notificationsDisabled())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var openSettingsButton: LargeClickZoneButton = { [weak self] in
        let btn = LargeClickZoneButton()
        btn.setTitle(Localized.openSettings(), for: .normal)
        btn.setTitleColor(Colors.blue(), for: .normal)
        btn.font = Fonts.interSemiBold(size: 14)
        btn.addTarget(self, action: #selector(openSettingsClick), for: .touchUpInside)
        return btn
    }()

    weak var delegate: NotificationsDisabledViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(backgroundView)
        [textLabel, iconImageView, openSettingsButton].forEach { backgroundView.addSubview($0)}
        backgroundView.autoPinEdgesToSuperviewEdges(with: .init(top: -13, left: 0, bottom: 0, right: 0))

        iconImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        iconImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 12)
        iconImageView.autoSetDimensions(to: .init(width: 20, height: 20))

        textLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        textLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        textLabel.autoPinEdge(.left, to: .right, of: iconImageView, withOffset: 8)

        openSettingsButton.autoPinEdge(.top, to: .bottom, of: textLabel)
        openSettingsButton.autoPinEdge(.left, to: .left, of: textLabel, withOffset: -8)
        openSettingsButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 7)
    }

    @objc private func openSettingsClick() {
        delegate?.openSettingsButtonClick()
    }

}
