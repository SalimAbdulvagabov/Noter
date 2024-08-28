//
//  LaunchViewController.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol LaunchViewInput: AlertPresentable, Loadable {
    func openNotesList()
}

final class LaunchViewController: UpdateStatusBarController {

    // MARK: - Views

    private lazy var iconImageView = UIImageView(image: Images.launchIcon())

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineSpacing(text: Localized.launchTitle(), spacing: 1.3)
        label.textColor = Colors.text()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Fonts.interSemiBold(size: 24)
        return label
    }()

    private lazy var setupSettingsButton: LargeClickZoneButton = { [weak self] in
        let btn = LargeClickZoneButton()
        btn.setTitle(Localized.launchSetupSettings(), for: .normal)
        btn.setTitleColor(Colors.blue(), for: .normal)
        btn.titleLabel?.font = Fonts.interSemiBold(size: 16)
        btn.setImage(Images.launchContinueArrow(), for: .normal)
        btn.addTarget(self, action: #selector(setupNotificationsClick), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        return btn
    }()

    private lazy var skipButton: ScalledButton = {
        let btn = ScalledButton()
        btn.setTitle(Localized.skip(), for: .normal)
        btn.setTitleColor(Colors.text(), for: .normal)
        btn.titleLabel?.font = Fonts.interMedium(size: 14)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.cornerRadius = 14
        btn.layer.cornerCurve = .continuous
        btn.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
        btn.backgroundColor = Colors.buttonBackground()
        return btn
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = Colors.loading()
        return indicator
    }()

    private lazy var loadingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.notesAreLoading()
        label.textColor = Colors.loading()
        label.font = Fonts.interSemiBold(size: 16)
        return label
    }()

    private let loadingView = UIView()
    private let promoStackView = UIStackView(axis: .vertical,
                                             spacing: 28,
                                             alignment: .fill)

    var presenter: LaunchViewOutput?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        Notifications.addObserver(self, selector: #selector(skipButtonClick), names: [.launchSettingsEnded])
    }

    deinit {
        Notifications.removeAllObservers(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewIsReady()
    }

    // MARK: - Drawing

    private func setupSubviews() {
        view.backgroundColor = Colors.screenBackground()
        loadingView.alpha = 0.0
        [loadingTitleLabel,
         loadingIndicator].forEach { loadingView.addSubview($0) }

        [iconImageView,
         skipButton,
         titleLabel,
         promoStackView,
         setupSettingsButton,
         loadingView].forEach { view.addSubview($0) }

        skipButton.autoPin(toTopLayoutGuideOf: self, withInset: 20)
        skipButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        skipButton.autoSetDimension(.width, toSize: 110)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        iconImageView.autoPin(toTopLayoutGuideOf: self, withInset: titleTopOffset)
        iconImageView.autoSetDimension(.height, toSize: 40)

        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(.top, to: .bottom, of: iconImageView, withOffset: 16)

        promoStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: promoTopOffset)
        promoStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 23)
        promoStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 23)

        setupSettingsButton.autoPinEdge(toSuperviewEdge: .left)
        setupSettingsButton.autoPinEdge(toSuperviewEdge: .right)
        setupSettingsButton.autoPin(toBottomLayoutGuideOf: self, withInset: 16)

        loadingView.autoAlignAxis(toSuperviewAxis: .vertical)
        loadingView.autoPin(toBottomLayoutGuideOf: self, withInset: 24)

        loadingTitleLabel.autoPinEdgesToSuperviewEdges(excludingEdge: .right)
        loadingTitleLabel.autoPinEdge(.right, to: .left, of: loadingIndicator, withOffset: -8)

        loadingIndicator.autoAlignAxis(.horizontal, toSameAxisOf: loadingTitleLabel)
        loadingIndicator.autoPinEdge(toSuperviewEdge: .right)
        loadingIndicator.autoSetDimensions(to: .init(width: 20, height: 20))
        setupPromoStackView()
    }

    private func setupPromoStackView() {
        let description1 = UILabel(text: Localized.launchDescription1())
        let description2 = UILabel(text: Localized.launchDescription2())
        let description3 = UILabel(text: Localized.launchDescription3())

        [description1, description2, description3].forEach {
            $0.font = Fonts.interRegular(size: 16)
            $0.textColor = Colors.text()
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.setLineSpacing(spacing: 4)
        }

        let image1 = UIImageView(image: Images.launchIcon1())
        let image2 = UIImageView(image: Images.launchIcon2())
        let image3 = UIImageView(image: Images.launchIcon3())

        [image1, image2, image3].forEach {
            $0.contentMode = .scaleAspectFit
            $0.autoSetDimensions(to: .init(width: 48,
                                           height: 48))
        }

        promoStackView.addArrangedSubviews([
            UIStackView(spacing: 25, arrangedSubviews: [image1, description1],
                        alignment: .top, distribution: .fill),
            UIStackView(spacing: 25, arrangedSubviews: [image2, description2],
                        alignment: .top, distribution: .fill),
            UIStackView(spacing: 25, arrangedSubviews: [image3, description3],
                        alignment: .top, distribution: .fill)
        ])

    }

    // MARK: - Actions

    @objc private func setupNotificationsClick() {
        presenter?.setupNotificationsButtonClick()
    }

    @objc private func skipButtonClick() {
        presenter?.skipButtonClick()
    }

}

// MARK: - LaunchViewInput
extension LaunchViewController: LaunchViewInput {
    func openNotesList() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = NoutesListAssembly.assembleModule()
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

    func showLoading() {
        loadingView.alpha = 0.0
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.setupSettingsButton.alpha = 0.0
            self?.skipButton.setTitleColor(Colors.placeholder(), for: .normal)
        } completion: { [weak self] (_) in
            self?.setupSettingsButton.isHidden = true
            self?.skipButton.isEnabled = false
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.loadingView.alpha = 1.0
            }
        }

        loadingIndicator.startAnimating()
    }

}

private let titleTopOffset: CGFloat = InterfaceUtils.hasMatch ? 80 : 64
private let promoTopOffset: CGFloat = InterfaceUtils.hasMatch ? 56 : 32
