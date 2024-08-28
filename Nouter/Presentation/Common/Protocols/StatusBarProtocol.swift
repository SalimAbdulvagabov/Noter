//
//  StatusBarProtocol.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.02.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol StatusBarProtocol: AnyObject {
    var statusBarStyle: UIStatusBarStyle? { get set }
}

class UpdateStatusBarController: UIViewController, StatusBarProtocol {
    var statusBarStyle: UIStatusBarStyle? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if statusBarStyle == nil {
            statusBarStyle = .default
        }
        let theme = DependecyContainer.shared.service.settings.getSettings().apperance
        switch theme {
        case .dark:
            return .lightContent
        case .system:
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return .lightContent
            }
        default:
            return statusBarStyle!
        }
        return statusBarStyle!
    }

}
