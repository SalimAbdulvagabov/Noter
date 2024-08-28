//
//  CellConfigurator.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

protocol ViewConfigurator {

    static var reuseId: String { get }

    func configure(cell: UIView)
    func associatedValue<T>() -> T?
}

protocol TableCellConfiguratorProtocol: ViewConfigurator {
    var cellHeight: CGFloat { get }
    var headerHeight: CGFloat { get }
}

protocol CollectionCellConfiguratorProtocol: ViewConfigurator {
    var size: CGSize { get }
}
