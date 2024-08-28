//
//  NewFolderViewOutput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol NewFolderViewOutput: ViewOutput {
    func closeButtonClick()
    func savebuttonClick(name: String, enabled: Bool)
}
