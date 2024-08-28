//
//  NewFolderViewInput.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.04.2021.
//  Copyright © 2021 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol NewFolderViewInput: AnyObject {
    func setupInitialState(name: String, enabled: Bool)
}
