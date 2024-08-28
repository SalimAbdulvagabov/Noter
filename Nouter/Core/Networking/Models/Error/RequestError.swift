import Foundation

public enum RequestError: Error {
    case unauthorizedRequest
    case pageNotFound
    case decodingError(String?)
    case unexpectedStatusCode(Int)
    case emptyQuery
    case unknown
    case custom(String)
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorizedRequest:
            return "Требуется авторизация"
        case .pageNotFound:
            return "Страница не найдена"
        case .decodingError(let detail):
            return "Ошибка декодирования объекта \(detail ?? "")"
        case .unexpectedStatusCode(let code):
            return "Сервер вернул ошибку с кодом \(code)"
        case .emptyQuery:
            return "Были переданы параметры с пустым значением"
        case .unknown:
            return "Неизвестная ошибка"
        case .custom(let message):
            return message
        }
    }
}
