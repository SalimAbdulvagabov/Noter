import Alamofire

public protocol IEndpoint {

    var baseUrl: URL { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: Alamofire.HTTPHeaders? { get }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

extension IEndpoint {

    var baseUrl: URL {
        URL(string: "https://api-noter.ru/")!
    }

    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.queryString
        default:
            return URLEncoding.default
        }
    }

    var parameters: Parameters? {
        nil
    }

    var headers: Alamofire.HTTPHeaders? {
        .init(["Api-Key": "6d0e1ff5-a27d-4a6d-bd64-c80abd7ac6bdTQ8l0jYRhAy8CqPqv8HLF2NSH3KVKA68"])
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .useDefaultKeys
    }

}
