//
//  DeleteNouteStatusView.swift
//  Nouter
//
//  Created by Салим Абдулвагабовon 10.01.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import VisualEffectView
import UIKit

protocol DeleteNouteStatusViewDelegate: AnyObject {
    func timerEnd()
    func cancelButtonClick()
}

final class DeleteNouteStatusView: UIView {

    // MARK: - Views

    private lazy var cancelButton: BaseButton = { [weak self] in
        let btn = BaseButton()
        btn.setTitle(Localized.cancel(), for: .normal)
        btn.setTitleColor(Colors.blue(), for: .normal)
        btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        btn.titleLabel?.font = Fonts.interSemiBold(size: 14)
        return btn
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.text()
        label.numberOfLines = 0
        label.font = Fonts.interRegular(size: 14)
        return label
    }()

    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.spacing = 16
        $0.axis = .horizontal
    }

    // MARK: - Private properties

    private var timer: Timer?

    // MARK: - Public props

    weak var delegate: DeleteNouteStatusViewDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Draw

    private func setupUI() {
        isHidden = true
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        clipsToBounds = true
        stackView.addArrangedSubviews([
            titleLabel,
            cancelButton
        ])

        let blurView = VisualEffectView()
        blurView.colorTint = Colors.deleteView()
        blurView.colorTintAlpha = 0.6
        blurView.blurRadius = 6
        blurView.scale = 1

        cancelButton.autoSetDimension(.width, toSize: 70)
        addSubview(blurView)
        blurView.autoPinEdgesToSuperviewEdges()
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: .init(horizontal: 16, vertical: 12))
    }

    // MARK: - Public funcs

    func showView(with model: Model) {
        titleLabel.text = model.text
        cancelButton.isHidden = !model.isCancelButtonShow

        timer = Timer.scheduledTimer(timeInterval: 5,
                                     target: self,
                                     selector: #selector(deleteTimeEnd),
                                     userInfo: nil,
                                     repeats: false)
        if isHidden {
            alpha = 0.0
            isHidden = false
        }
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.alpha = 1.0
        }
    }

    func hideView() {
        timer?.invalidate()
        alpha = 1.0
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.alpha = 0.0
        } completion: { [weak self] (finished) in
            if finished {
                self?.isHidden = true
            }
        }

    }

    // MARK: - Actions

    @objc private func cancelClick() {
        hideView()
        delegate?.cancelButtonClick()
    }

    @objc private func deleteTimeEnd() {
        hideView()
        delegate?.timerEnd()
    }

}

extension DeleteNouteStatusView {
    struct Model {
        let text: String
        let isCancelButtonShow: Bool
    }
}

private let animationTime: Double = 0.25
