//
//  UIViewController+BottomSheet.swift
//  05.ru
//
//  Created by Рамазан on 21.07.2020.
//  Copyright © 2020 Рамазан. All rights reserved.
//

import UIKit

extension UIViewController {

    func showSheetViewController(controller: UIViewController,
                                 sizes: [SheetSize]) {
        let options = SheetOptions(
            pullBarHeight: 12,
            gripColor: .clear,
            shrinkPresentingViewController: true
        )
        let sheetController = SheetViewController(controller: controller, sizes: sizes, options: options)
        sheetController.cornerRadius = 16
        sheetController.allowPullingPastMaxHeight = true
        self.present(sheetController, animated: true, completion: nil)
    }

}
