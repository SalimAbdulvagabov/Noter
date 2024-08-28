//
//  UIDevice+Extensions.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 10.10.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
