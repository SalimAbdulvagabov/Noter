//
//  WeReturnViewController.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class WeReturnViewController: UIViewController {

    // MARK: - Properties

    private lazy var imageView = UIImageView(image: Images.weReturn())

    private lazy var closeButton: BaseButton = { [unowned self] in
        let btn = BaseButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return btn
    }()

    private lazy var continueButton: BlueButton = { [unowned self] in
        let btn = BlueButton()
        btn.setTitle(Localized.continue(), for: .normal)
        btn.titleLabel?.font = Fonts.interSemiBold(size: 16)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        btn.addAction(.init(handler: { [unowned self] _ in
            self.closeButtonClick()
        }), for: .touchUpInside)
        return btn
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineSpacing(text: Localized.weReturnTitle(), spacing: 1.3)
        label.textColor = Colors.text()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Fonts.interSemiBold(size: 24)
        return label
    }()

    private lazy var descriprionLabel: UILabel = {
        let label = UILabel()
        label.setTextWithLineSpacing(text: Localized.weReturnDescription(), spacing: 1.3)
        label.textColor = Colors.loading()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Fonts.interRegular(size: 16)
        return label
    }()

    private var viewModel: SettingsViewModel?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.resize(to: .fixed(PopUpsHeights.weReturn.value))
    }

    // MARK: - Drawing

    private func setupSubviews() {
        view.backgroundColor = Colors.screenBackground()
        imageView.contentMode = .scaleAspectFit

        [
            closeButton,
            imageView,
            titleLabel,
            descriprionLabel,
            continueButton
        ].forEach {
            view.addSubview($0)
        }

        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        closeButton.autoPinEdge(toSuperviewEdge: .right, withInset: 12)

        imageView.autoPinEdge(toSuperviewEdge: .top, withInset: 58)
        imageView.autoAlignAxis(toSuperviewAxis: .vertical)
        imageView.autoSetDimensions(to: .init(width: 220, height: 220))

        titleLabel.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: 8)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)

        descriprionLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 8)
        descriprionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        descriprionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 16)

        continueButton.autoPinEdge(.top, to: .bottom, of: descriprionLabel, withOffset: 40)
        continueButton.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        continueButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        continueButton.autoSetDimension(.height, toSize: 44)
    }

    // MARK: - Private funcs

    @objc private func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }

}
