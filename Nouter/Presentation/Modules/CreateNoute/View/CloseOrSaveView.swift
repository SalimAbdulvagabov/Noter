//
//  CloseOrSaveView.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 14.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol CloseOrSaveViewDelegate: AnyObject {
    func closeButtonClick()
    func saveButtonClick()
}

final class CloseOrSaveView: UIView {

    private lazy var closeButton: ScalledButton = {
        let btn = LargeClickZoneButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return btn
    }()

    private lazy var saveButton: ScalledButton = {
        let btn = ScalledButton()
        btn.setTitle(Localized.done(), for: .normal)
        btn.setTitleColor(Colors.text(), for: .normal)
        btn.titleLabel?.font = Fonts.interMedium(size: 14)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.cornerRadius = 14
        btn.layer.cornerCurve = .continuous
        btn.addTarget(self, action: #selector(saveClick), for: .touchUpInside)
        btn.backgroundColor = Colors.buttonBackground()
        btn.titleLabel?.alpha = 0.0
        return btn
    }()

    weak var delegate: CloseOrSaveViewDelegate?

    var state: State = .close {
        didSet {
            switch state {
            case .close:
                showCloseButton()
            case .save:
                showSaveButton()
            }
        }
    }

    private var saveButtonleadingAnch: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(saveButton)
        addSubview(closeButton)
        self.autoSetDimension(.width, toSize: width)
        saveButton.autoPinEdgesToSuperviewEdges(with: .init(top: 8, left: 8, bottom: 8, right: 8), excludingEdge: .left)
        saveButtonleadingAnch = saveButton.autoPinEdge(toSuperviewEdge: .left, withInset: width - 28)
        saveButton.autoSetDimension(.height, toSize: 28)
        closeButton.autoPinEdge(.right, to: .right, of: saveButton, withOffset: 8)
        closeButton.autoAlignAxis(.horizontal, toSameAxisOf: saveButton)
    }

    @objc private func closeClick() {
        delegate?.closeButtonClick()
    }

    @objc private func saveClick() {
        delegate?.saveButtonClick()
    }

    private func showSaveButton() {
        if closeButton.alpha == 0.0 { return }
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.closeButton.alpha = 0.0
            self?.saveButtonleadingAnch.constant = 8
            self?.layoutIfNeeded()
        } completion: { finished in
            if finished {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.saveButton.titleLabel?.alpha = 1.0
                }
            }
        }
    }

    private func showCloseButton() {
        if closeButton.alpha == 1.0 { return }
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.closeButton.alpha = 1.0
            self?.saveButton.titleLabel?.alpha = 0.0
            self?.saveButtonleadingAnch.constant = width - 28
            self?.layoutIfNeeded()
        }
    }

}

extension CloseOrSaveView {
    enum State {
        case close
        case save
    }
}

private let width: CGFloat = 91
