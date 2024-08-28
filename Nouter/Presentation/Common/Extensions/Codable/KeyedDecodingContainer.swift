//
//  KeyedDecodingContainer.swift
//  05.ru
//
//  Created by Салим Абдулвагабов on 16.05.2020.
//  Copyright © 2020 Салим Абдулвагабов. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

    // MARK: - Syntax Sugar

    func decode<T: Decodable>(key: Key) throws -> T {
        return try self.decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(key: Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

    // MARK: - Default Value

    func decode<T: Decodable>(key: Key, defaultValue defaultExpression: @autoclosure () -> T) throws -> T {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }

    // MARK: - Safe Decoding

    func decodeSafely<T: Decodable>(key: Key) -> T? {
        return self.decodeSafely(T.self, forKey: key)
    }

    func decodeSafely<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        let decoded = try? decode(Safe<T>.self, forKey: key)
        return decoded?.value
    }

    func decodeSafelyIfPresent<T: Decodable>(key: Key) -> T? {
        return self.decodeSafelyIfPresent(T.self, forKey: key)
    }

    func decodeSafelyIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key) -> T? {
        let decoded = try? decodeIfPresent(Safe<T>.self, forKey: key)
        return decoded?.value
    }

    func decodeSafelyArray<T: Decodable>(of type: T.Type, forKey key: Key) -> [T] {
        let array = decodeSafely([Safe<T>].self, forKey: key)
        return array?.compactMap { $0.value } ?? []
    }

}
