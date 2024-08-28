//
//  NewFolderViewController.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class NewFolderViewController: UIViewController {

    // MARK: - Views

    private lazy var closeButton: LargeClickZoneButton = { [weak self] in
        let btn = LargeClickZoneButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return btn
    }()

    private lazy var nameTextField: UITextField = { [weak self] in
        let textField = PaddedTextField()
        textField.textInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
        textField.cornerRadius = 8
        textField.borderWidth = 1
        textField.delegate = self
        textField.borderColor = Colors.folderInputBorder()
        textField.textColor = Colors.text()
        textField.font = Fonts.interRegular(size: 16)
        return textField
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.newFolderName()
        label.textAlignment = .left
        label.textColor = Colors.text()
        label.font = Fonts.interMedium(size: 16)
        return label
    }()

    private lazy var notificationSwitch: UISwitch = {
        let swt = UISwitch()
        swt.isOn = true
        let imageView = Images.arrowRightIcon()
        swt.onImage = imageView
        swt.onTintColor = Colors.blue()
        swt.addAction(for: .valueChanged) { [weak self] in
            if self?.nameTextField.text != "" {
                self?.saveButton.isEnabled = true
            }
        }
        return swt
    }()

    private lazy var notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = Localized.showNotifications()
        label.textColor = Colors.text()
        label.font = Fonts.interMedium(size: 16)
        return label
    }()

    private lazy var notificationsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.notificationsIcon()
        return imageView
    }()

    private lazy var saveButton: LargeClickZoneButton = {
        let btn = LargeClickZoneButton()
        btn.setImage(Images.folderSaveEnabled(), for: .normal)
        btn.setImage(Images.folderSaveDisabled(), for: .disabled)
        btn.setTitle(Localized.newFolderSave(), for: .normal)
        btn.setTitleColor(Colors.blue(), for: .normal)
        btn.setTitleColor(UIColor(rgb: 0x8B94A7), for: .disabled)
        btn.semanticContentAttribute = .forceLeftToRight
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btn.titleLabel?.font = Fonts.interSemiBold(size: 16)
        btn.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    // MARK: - Properties

    var output: NewFolderViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        addTapOnKeyboardHiding()
        output?.viewIsReady()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.nameTextField.becomeFirstResponder()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillAppear() {
        nameTextField.borderColor = Colors.blue()
    }

    @objc private func keyboardWillDisappear() {
        nameTextField.borderColor = Colors.folderInputBorder()
    }

    private func setupSubviews() {
        title = Localized.newFolder()
        view.backgroundColor = Colors.screenBackground()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

        view.addSubview(nameLabel)
        nameLabel.autoPin(toTopLayoutGuideOf: self, withInset: 16)
        nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)

        view.addSubview(nameTextField)
        nameTextField.autoPinEdge(.top, to: .bottom, of: nameLabel, withOffset: 8)
        nameTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        nameTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        nameTextField.autoSetDimension(.height, toSize: 43)

        view.addSubview(notificationsImageView)
        notificationsImageView.autoPinEdge(.top, to: .bottom, of: nameTextField, withOffset: 28)
        notificationsImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        notificationsImageView.autoSetDimensions(to: .init(width: 32, height: 32))

        view.addSubview(notificationsLabel)
        notificationsLabel.autoAlignAxis(.horizontal, toSameAxisOf: notificationsImageView)
        notificationsLabel.autoPinEdge(.left, to: .right, of: notificationsImageView, withOffset: 12)

        view.addSubview(notificationSwitch)
        notificationSwitch.autoAlignAxis(.horizontal, toSameAxisOf: notificationsImageView)
        notificationSwitch.autoPinEdge(toSuperviewEdge: .right, withInset: 20)

        view.addSubview(saveButton)
        saveButton.autoPinEdge(toSuperviewEdge: .left)
        saveButton.autoPinEdge(toSuperviewEdge: .right)
        saveButton.autoPinEdge(.top, to: .bottom, of: notificationsImageView, withOffset: 28)
    }

    private func resize() {
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.resize(to: .fixed(PopUpsHeights.newFolder.value))
    }

    @objc private func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func saveButtonClick() {
        guard let text = nameTextField.text, text != "" else {
            closeButtonClick()
            return
        }
        output?.savebuttonClick(name: text, enabled: notificationSwitch.isOn)
        closeButtonClick()
    }

}

extension NewFolderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        saveButton.isEnabled = true
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 14
    }
}

extension NewFolderViewController: NewFolderViewInput {
    func setupInitialState(name: String, enabled: Bool) {
        nameTextField.text = name
        notificationSwitch.isOn = enabled
    }
}
