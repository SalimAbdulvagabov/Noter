//
//  InteractorOutput.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 29.09.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

protocol InteractorOutput: AnyObject {
    func errorLoading(_ error: ParsableError)
    func networkError()
    func notAuthorizedError()
    func decodingError()

}

extension InteractorOutput {
    func networkError() { }
    func notAuthorizedError() { }
    func decodingError() { }
}
