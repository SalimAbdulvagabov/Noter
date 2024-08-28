//
//  WeReturnAssembly.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 24.12.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import UIKit

struct WeReturnAssembly: Assembly {
    static func assembleModule() -> UIViewController {
        WeReturnViewController()
    }
}
