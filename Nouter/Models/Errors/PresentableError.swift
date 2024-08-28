//
//  PresentableError.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol PresentableError where Self: Error {
    var userMessage: String { get }
    var isNetworkError: Bool { get }
}

extension APIError {

    var isNetworkError: Bool {
        switch self {
        case .noNetwork:    return true
        default:            return false
        }
    }

}
