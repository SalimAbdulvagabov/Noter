//
//  UIViewController+Extension.swift
//  05.ru
//
//  Created by Рамазан on 15.06.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - Add navigationController to ViewController

    func wrappedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }

    // MARK: - Tap gesture for hide keyboard

    func addTapOnKeyboardHiding() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
