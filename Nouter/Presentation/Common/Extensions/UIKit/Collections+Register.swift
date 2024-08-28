//
//  Collections+Register.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 17.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import UIKit

extension UICollectionView {

    func register(cellTypes: [UICollectionViewCell.Type]) {

        cellTypes.forEach {
            let reuseIdentifier = $0.className
            register($0, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }

}

extension UITableView {

    func register(cellTypes: [UITableViewCell.Type]) {

        cellTypes.forEach {
            let reuseIdentifier = $0.className
            register($0, forCellReuseIdentifier: reuseIdentifier)
        }
    }
}
