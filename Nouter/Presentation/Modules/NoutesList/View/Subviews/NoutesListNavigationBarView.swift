//
//  NoutesListNavigationBarView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.10.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import VisualEffectView

protocol NoutesListNavigationBarViewDelegate: AnyObject {
    func settingsButtonClick()
    func foldersButtonClick()
}

final class NoutesListNavigationBarView: UIView {

    private lazy var folderButton: ScalledButton = { [weak self] in
        let btn = ScalledButton()
        btn.font = Fonts.interSemiBold(size: 18)
        btn.setTitleColor(Colors.text(), for: .normal)
        btn.addTarget(self, action: #selector(foldersButtonClick), for: .touchUpInside)
        return btn
    }()

    lazy private var settingsButton: LargeClickZoneButton = { [weak self] in
        let btn = LargeClickZoneButton()
        btn.setImage(Images.settingsIcon(), for: .normal)
        btn.addTarget(self, action: #selector(settingsButtonClick), for: .touchUpInside)
        return btn
    }()

    private var titleBottomConstraint: NSLayoutConstraint?

    weak var delegate: NoutesListNavigationBarViewDelegate?

    var text: String = Localized.notes() {
        didSet {
            folderButton.setTitle(text, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        clipsToBounds = true
        let blurView = VisualEffectView()
        blurView.colorTint = Colors.screenBackground()
        blurView.colorTintAlpha = 0.9
        blurView.blurRadius = 6
        blurView.scale = 1
        addSubview(blurView)
        blurView.autoPinEdgesToSuperviewEdges()
        addSubview(folderButton)
        addSubview(settingsButton)
        titleBottomConstraint = folderButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: -30)
        folderButton.autoAlignAxis(toSuperviewAxis: .vertical)
        settingsButton.autoAlignAxis(.horizontal, toSameAxisOf: folderButton)
        settingsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 12)
    }

    @objc private func settingsButtonClick() {
        delegate?.settingsButtonClick()
    }

    @objc private func foldersButtonClick() {
        delegate?.foldersButtonClick()
    }

    func contentPosition(value: CGFloat) {
        if value < bootomSpacing {
            folderButton.alpha = 1.0
            settingsButton.alpha = 1.0
            titleBottomConstraint?.constant = bootomSpacing
            return
        }
        folderButton.alpha = value / -8
        settingsButton.alpha = value / -8
        titleBottomConstraint?.constant = value
        layoutIfNeeded()
    }

}

private let bootomSpacing: CGFloat = -11
