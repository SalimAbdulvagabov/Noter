//
//  ParsableError.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2022.
//  Copyright © 2022 Салим Абдулвагабов. All rights reserved.
//

import Foundation

struct ParsableError: Decodable, PresentableError {

    // MARK: - Properties

//    private let message: String
    let type: String
    let message: String?
    let description: String?

    // MARK: - Nested struct

    struct DetailError: Decodable {
        let name: String
        let message: String
    }

    // MARK: - PresentableError

    var userMessage: String {
        return message ?? ""
    }

    var isNetworkError: Bool {
        return false
    }
}
