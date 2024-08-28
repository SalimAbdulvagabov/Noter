//
//  AlertPresentable.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol AlertPresentable: AnyObject {
    func showAlert(title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    func showAlert(title: String?, message: String?, actions: [AlertAction])
}

extension AlertPresentable where Self: UIViewController {

    func showAlert(title: String?, message: String?, actions: [AlertAction]) {
        showAlert(title: title, message: message, actions: actions, style: .alert)
    }

    func showAlert(title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        let alertActions = actions.map { (action) in
            return UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                action.action?()
            })
        }

        alertActions.forEach {
            alert.addAction($0)
        }

        present(alert, animated: true, completion: nil)
    }
}
