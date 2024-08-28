//
//  LaunchSettingsViewController.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class LaunchSettingsViewController: UIViewController {

    // MARK: - Views

    private lazy var startDateTextField = UITextField()
    private lazy var endDateTextField = UITextField()
    private lazy var repeatabilityTextField = UITextField()

    private lazy var closeButton: BaseButton = { [weak self] in
        let btn = BaseButton()
        btn.setImage(Images.closeIcon(), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return btn
        }()

    private lazy var notificationsDisabledView: NotificationsDisabledView = { [weak self] in
        let view =  NotificationsDisabledView()
        view.delegate = self?.presenter as? NotificationsDisabledViewDelegate
        return view
    }()

    private lazy var timesStackView = UIStackView(axis: .vertical,
                                                  spacing: 16,
                                                  translatesAutoresizingMask: false,
                                                  distribution: .fill)

    private lazy var saveSettingsButton: LargeClickZoneButton = { [weak self] in
        let btn = LargeClickZoneButton()
        btn.setImage(Images.launchContinueArrow(), for: .normal)
        btn.setTitle(Localized.saveSettings(), for: .normal)
        btn.setTitleColor(Colors.blue(), for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        btn.titleLabel?.font = Fonts.interSemiBold(size: 16)
        btn.addTarget(self, action: #selector(saveSettingsButtonClick), for: .touchUpInside)
        return btn
    }()

    // MARK: - Properties

    var presenter: NotificationsSettingsViewOutput?
    private var settingsModel: SettingsModel!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        presenter?.viewIsReady()
        addTapOnKeyboardHiding()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.didDisappear(with: settingsModel)
    }

    // MARK: - Drawing
    // swiftlint:disable function_body_length
    private func setupSubviews() {
        view.backgroundColor = Colors.screenBackground()
        title = Localized.notifications()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)

        let startDateLabel = UILabel(text: Localized.startTime())
        let endDateLabel = UILabel(text: Localized.endTime())
        let repeatabilityLabel = UILabel(text: Localized.periodicity())

        [startDateLabel, endDateLabel, repeatabilityLabel].forEach {
            $0.textColor = Colors.text()
            $0.font = Fonts.interMedium(size: 16)
        }

        [startDateTextField, endDateTextField, repeatabilityTextField].forEach {
            $0.textColor = Colors.text()
            $0.font = Fonts.interMedium(size: 16)
            $0.textAlignment = .right
            $0.tintColor = .clear
        }

        let startDateSV = UIStackView(arrangedSubviews: [startDateLabel,
                                                         startDateTextField],
                                      distribution: .equalSpacing)
        startDateSV.addTapGestureRecognizer { [weak self] in
            self?.startDateTextField.becomeFirstResponder()
        }

        let endDateSV = UIStackView(arrangedSubviews: [endDateLabel,
                                                       endDateTextField],
                                    distribution: .equalSpacing)

        endDateSV.addTapGestureRecognizer { [weak self] in
            self?.endDateTextField.becomeFirstResponder()
        }

        let repeatabilitySV = UIStackView(arrangedSubviews: [repeatabilityLabel,
                                                             repeatabilityTextField],
                                          distribution: .equalSpacing)

        repeatabilitySV.addTapGestureRecognizer { [weak self] in
            self?.repeatabilityTextField.becomeFirstResponder()
        }

        let firstSeparator = UIView()
        let secondSeparator = UIView()
        [firstSeparator, secondSeparator].forEach {
            $0.backgroundColor = Colors.separator()
            $0.autoSetDimension(.height, toSize: 1)
        }

        timesStackView.addArrangedSubviews([startDateSV,
                                            firstSeparator,
                                            endDateSV,
                                            secondSeparator,
                                            repeatabilitySV])

        let titleLabel = UILabel(text: "Когда тебе удобнее\nполучать уведомления?")
        titleLabel.font = Fonts.interSemiBold(size: 18)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left

        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(timesStackView)
        view.addSubview(saveSettingsButton)

        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)

        closeButton.autoPinEdge(toSuperviewEdge: .right, withInset: 12)
        closeButton.autoPinEdge(toSuperviewEdge: .top, withInset: 12)

        timesStackView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 36)
        timesStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        timesStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)

        saveSettingsButton.autoPinEdge(.top, to: .bottom, of: timesStackView, withOffset: 36)
        saveSettingsButton.autoPinEdge(toSuperviewEdge: .left)
        saveSettingsButton.autoPinEdge(toSuperviewEdge: .right)
    }

    private func updatePickers() {
        startDateTextField.text = settingsModel.startTime.timeDescription
        endDateTextField.text = settingsModel.endTime.timeDescription
        repeatabilityTextField.text = settingsModel.repeatability.name

        startDateTextField.setInputViewDatePicker(target: self,
                                                  selector: #selector(doneClick),
                                                  currentVariation: settingsModel.startTime.date)
        endDateTextField.setInputViewDatePicker(target: self,
                                                selector: #selector(doneClick),
                                                currentVariation: settingsModel.endTime.date)
        repeatabilityTextField.setInputViewPicker(target: self,
                                                  currentIndex: settingsModel.repeatability.rawValue,
                                                  selector: #selector(doneClick),
                                                  dataSource: self)
    }

    private func setTimeValue(_ date: Date, textField: UITextField) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        dateFormater.locale = Locale(identifier: "ru_RU")
        textField.text = dateFormater.string(from: date)
    }

    // MARK: - Actions

    @objc private func saveSettingsButtonClick() {
        dismiss(animated: true) {
            Notifications.post(name: .launchSettingsEnded)
        }
    }

    @objc private func closeButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func doneClick() {
        defer {
            updatePickers()
            dismissKeyboard()
        }

        if startDateTextField.isFirstResponder {
            guard let picker = startDateTextField.inputView as? UIDatePicker else {
                return
            }

            let value = Time(picker.date)
            if settingsModel.endTime < value {
                settingsModel.endTime = value
            }

            settingsModel.startTime = value
            return
        }

        if endDateTextField.isFirstResponder {
            guard let picker = endDateTextField.inputView as? UIDatePicker else {
                return
            }

            let value = Time(picker.date)
            if settingsModel.startTime > value {
                settingsModel.startTime = value
            }

            settingsModel.endTime = value
            return
        }

        if repeatabilityTextField.isFirstResponder {
            guard let picker = repeatabilityTextField.inputView as? UIPickerView,
                  let value = RepeatabilityNotifications(rawValue: picker.selectedRow(inComponent: 0)) else {
                return
            }
            settingsModel.repeatability = value
        }

    }

    @objc private func notificationSwitch(_ sender: UISwitch) {
        settingsModel.notificationsEnabled = sender.isOn
    }

}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension LaunchSettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RepeatabilityNotifications.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RepeatabilityNotifications(rawValue: row)?.name
    }

}

// MARK: - NotificationsSettingsViewInput
extension LaunchSettingsViewController: NotificationsSettingsViewInput {
    func update(with viewModel: SettingsModel) {
        self.settingsModel = viewModel
        updatePickers()
    }

}

private let dateFormat = "HH:mm"
