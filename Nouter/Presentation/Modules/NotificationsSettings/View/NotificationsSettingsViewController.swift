//
//  NotificationsSettingsViewController.swift
//  AppName
//
//  Created Салим Абдулвагабов on 01.01.1945.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol NotificationsSettingsViewInput: AlertPresentable, Loadable {
    func update(with viewModel: SettingsModel)
}

final class NotificationsSettingsViewController: UIViewController {

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

    private lazy var notificationSwitch: UISwitch = { [weak self] in
        let swview = UISwitch()
        let imageView =  Images.arrowRightIcon()
        swview.onImage = imageView
        swview.onTintColor = Colors.blue()
        swview.addTarget(self, action: #selector(notificationSwitch(_:)), for: .valueChanged)
        return swview
    }()

    private lazy var notificationsStackView = UIStackView(axis: .vertical,
                                                          spacing: 16,
                                                          translatesAutoresizingMask: false,
                                                          distribution: .fill)

    private lazy var timesStackView = UIStackView(axis: .vertical,
                                                  spacing: 16,
                                                  translatesAutoresizingMask: false,
                                                  distribution: .fill)

    private var notificationsEnabled: Bool = true

    // MARK: - Properties

    var presenter: NotificationsSettingsViewOutput?
    private var settingsModel: SettingsModel!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkNotifications()
        setupSubviews()
        presenter?.viewIsReady()
        addTapOnKeyboardHiding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationsDisabledView.isHidden = notificationsEnabled
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let controller = self.navigationController?.parent?.parent as? SheetViewController else { return }
        controller.resize(to: .fixed(PopUpsHeights.notificationsFromSettings(append: notificationsEnabled ? 0 : 100).value))
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
        let showNotificationsLabel = UILabel(text: Localized.showNotifications())

        [startDateLabel, endDateLabel, repeatabilityLabel, showNotificationsLabel].forEach {
            $0.textColor = Colors.text()
            $0.font = Fonts.interMedium(size: 16)
        }

        [startDateTextField, endDateTextField, repeatabilityTextField].forEach {
            $0.textColor = Colors.text()
            $0.font = Fonts.interMedium(size: 16)
            $0.textAlignment = .right
            $0.tintColor = .clear
        }

        let showNotificationsSV = UIStackView(arrangedSubviews: [showNotificationsLabel,
                                                                 notificationSwitch],
                                              distribution: .equalSpacing)

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

        notificationsStackView.addArrangedSubviews([notificationsDisabledView,
                                                    showNotificationsSV])

        notificationsStackView.addTapGestureRecognizer { [weak self] in
            self?.notificationSwitch.setOn(!(self?.notificationSwitch.isOn ?? false), animated: true)
        }

        view.addSubview(notificationsStackView)

        let bigSeparator = UIView()
        bigSeparator.backgroundColor = Colors.separator()
        view.addSubview(bigSeparator)

        timesStackView.addArrangedSubviews([startDateSV,
                                            firstSeparator,
                                            endDateSV,
                                            secondSeparator,
                                            repeatabilitySV])

        view.addSubview(timesStackView)

        notificationsStackView.autoPin(toTopLayoutGuideOf: self, withInset: 25)
        notificationsStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        notificationsStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)

        bigSeparator.autoSetDimension(.height, toSize: 16)
        bigSeparator.autoPinEdge(.top, to: .bottom, of: notificationsStackView, withOffset: 16)
        bigSeparator.autoPinEdge(toSuperviewEdge: .left)
        bigSeparator.autoPinEdge(toSuperviewEdge: .right)

        timesStackView.autoPinEdge(.top, to: .bottom, of: bigSeparator, withOffset: 16)
        timesStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        timesStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
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

    private func checkNotifications() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { [weak self] (settings) in
            self?.notificationsEnabled = settings.authorizationStatus == .authorized
        })
    }

    // MARK: - Actions

    @objc private func closeButtonClick() {
        presenter?.closeButtonClick()
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
        presenter?.switchNotifications(isOn: sender.isOn)
    }

}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension NotificationsSettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
extension NotificationsSettingsViewController: NotificationsSettingsViewInput {
    func update(with viewModel: SettingsModel) {
        self.settingsModel = viewModel
        notificationSwitch.setOn(viewModel.notificationsEnabled, animated: false)
        updatePickers()
    }

}

extension NotificationsSettingsViewController: NotificationsDisabledViewDelegate {
    func openSettingsButtonClick() {

    }
}

private let dateFormat = "HH:mm"
