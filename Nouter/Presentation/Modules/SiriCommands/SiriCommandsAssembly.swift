//
//  SiriCommandsAssembly.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 19.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class SiriCommandsAssembly: Assembly {

    static func assembleModule() -> UIViewController {
        let siriManager = DependecyContainer.shared.core.siri
        let viewModel = SiriCommandsViewModel(siriManager: siriManager)
        let view = SiriCommandsViewController(viewModel: viewModel)

        return view
    }

}
