//
//  AlertAction.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: (() -> Void)?
}

// let AlertCancelAction = AlertAction(title: Localized.cancel(), style: .cancel, action: nil)
