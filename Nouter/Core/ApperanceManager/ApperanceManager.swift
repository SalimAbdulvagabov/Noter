//
//  ApperanceManager.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 20.03.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import UIKit

final class ApperanceManager {

    var currentIcon: AppIconType {
        return AppIconType.allCases.first(where: {
            $0.decodeValue == UIApplication.shared.alternateIconName
        }) ?? .bluewLightLines
    }

    func changeApperance(theme: ThemeType) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.overrideUserInterfaceStyle = theme.value
    }

    func changeIcon(_ appIcon: AppIconType, completion: ((Bool) -> Void)? = nil) {
        guard currentIcon != appIcon,
              UIApplication.shared.supportsAlternateIcons
        else { return }

        UIApplication.shared.setAlternateIconName(appIcon.decodeValue) { error in
            if let error = error {
                print("Error setting alternate icon \(appIcon.decodeValue ): \(error.localizedDescription)")
            }
            completion?(error != nil)
        }
    }

    func setupInitialState() {
        let settings = DependecyContainer.shared.service.settings.getSettings()
        changeIcon(settings.appIcon)
        changeApperance(theme: settings.apperance)
    }

}
