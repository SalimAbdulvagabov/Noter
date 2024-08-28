//
//  NoutesListHeaderView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.10.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation
import UIKit

final class NoutesListHeaderView: UIView {

    private lazy var folderButton: ScalledButton = { [weak self] in
        let btn = ScalledButton()
        btn.font = Fonts.interSemiBold(size: 28)
        btn.setTitleColor(Colors.text(), for: .normal)
        btn.titleLabel?.numberOfLines = 1
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.lineBreakMode = .byClipping
        btn.setImage(Images.foldersArrowDown(), for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(foldersButtonClick), for: .touchUpInside)
        return btn
    }()

    private lazy var settingsButton: LargeClickZoneButton = { [weak self] in
        let btn = LargeClickZoneButton()
        btn.setImage(Images.settingsIcon(), for: .normal)
        btn.addTarget(self, action: #selector(settingsButtonClick), for: .touchUpInside)
        return btn
    }()

    private var buttonLeadingConstraint: NSLayoutConstraint?
    // MARK: - ***MAGIC***
    var scrollOffset: CGFloat = 0 {
        didSet {
//            let fontSize: CGFloat = 28
//            let value = fontSize + (-scrollOffset/70)
//            if value > 31 || value < 28  {
//                return
//            }
//            let scaleValue = value/fontSize
//            folderButton.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
//            buttonLeadingConstraint?.constant = leadingOffset + (-(scrollOffset)/30)
//            layoutIfNeeded()
        }
    }

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
        backgroundColor = Colors.screenBackground()
        addSubview(folderButton)
        addSubview(settingsButton)
        folderButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        buttonLeadingConstraint = folderButton.autoPinEdge(toSuperviewEdge: .left, withInset: leadingOffset)
        settingsButton.autoAlignAxis(.horizontal, toSameAxisOf: folderButton)
        settingsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 12)
    }

    @objc private func settingsButtonClick() {
        delegate?.settingsButtonClick()
    }

    @objc private func foldersButtonClick() {
        delegate?.foldersButtonClick()
    }

}

private let leadingOffset: CGFloat = 20
