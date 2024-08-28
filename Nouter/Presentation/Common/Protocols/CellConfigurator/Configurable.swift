//
//  Configurable.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

protocol Configurable {

    associatedtype Model
    func configure(with model: Model)
}
