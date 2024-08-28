//
//  UITextField+Extensions.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 04.12.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//
import UIKit
import Foundation

extension UITextField {

    func setInputViewDatePicker(target: Any,
                                selector: Selector,
                                currentVariation: Date,
                                datePickerMode: UIDatePicker.Mode = .time,
                                minimumDate: Date? = nil,
                                maximumDate: Date? = nil) {
        let screenWidth = InterfaceUtils.screenWidth
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .wheels

        var components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        components.hour = (components.hour ?? 0) + 1
        components.minute = 0

        datePicker.date = currentVariation

        datePicker.minuteInterval = 15
        datePicker.backgroundColor = Colors.screenBackground()
        datePicker.setValue(Colors.text(), forKeyPath: "textColor")
        datePicker.locale = Locale(identifier: "ru_RU")
        self.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: Localized.cancel(), style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: Localized.done(), style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func tapCancel() {
        self.resignFirstResponder()
    }

    func setInputViewPicker(target: Any, currentIndex: Int, selector: Selector, dataSource: UIPickerViewDataSource) {
        let screenWidth = InterfaceUtils.screenWidth
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        picker.delegate = dataSource as? UIPickerViewDelegate
        picker.dataSource = dataSource
        picker.backgroundColor = Colors.screenBackground()
        picker.selectRow(currentIndex, inComponent: 0, animated: false)
        picker.setValue(Colors.text(), forKeyPath: "textColor")
        self.inputView = picker

        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: Localized.cancel(), style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: Localized.done(), style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

}
