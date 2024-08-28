//
//  SeparatorCell.swift
//  Nouter
//
//  Created by Салим Абдулвагабов on 27.10.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

typealias SeparatorCellConfigurator = TableCellConfigurator<SeparatorCell, SeparatorCell.Model>

final class SeparatorCell: UITableViewCell {}

extension SeparatorCell: Configurable {
    typealias Model = UIColor

    func configure(with model: UIColor) {
        selectionStyle = .none
        backgroundColor = model
    }
}
