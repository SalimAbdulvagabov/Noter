import Combine
import Alamofire
import Foundation

public protocol INetworkProvider: AnyObject {
    func request<Output: Decodable>(ofType type: Output.Type, to endpoint: IEndpoint) -> AnyPublisher<Output, RequestError>
    func request<Response: Decodable>(endpoint: IEndpoint, completion: @escaping (Result<Response, Error>) -> Void)
}

public final class NetworkProvider: INetworkProvider {
    private let decoder = JSONDecoder()

    public func request<Output: Decodable>(ofType type: Output.Type, to endpoint: IEndpoint) -> AnyPublisher<Output, RequestError> {

        decoder.keyDecodingStrategy = endpoint.keyDecodingStrategy

        return Future<Output, RequestError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }

            let url = endpoint.baseUrl.appendingPathComponent(endpoint.path)

            AF.request(url,
                       method: endpoint.method,
                       parameters: endpoint.parameters,
                       headers: endpoint.headers)
                .responseJSON { response in
                    print("\n")
                    print("url - \(url)")
                    print("parameters - \(endpoint.parameters ?? [:])")
                    print("headers - \(endpoint.headers ?? [:])")
                    if let responseError = self.validateResponse(response.response) {
                        print("error- \(responseError)")
                        promise(.failure(responseError))
                        return
                    }

                    guard let data = response.data else {
                        promise(.failure(.unknown))
                        return
                    }
                    print("data - \(String(data: data, encoding: .utf8) ?? "")")

                    do {
                        let model = try self.decoder.decode(Output.self, from: data)
                        promise(.success(model))
                    } catch let error {
                        print("error- \(error)")
                        promise(.failure(.custom(error.localizedDescription)))
                    }
                }

        }
        .eraseToAnyPublisher()
    }

    public func request<Response: Decodable>(endpoint: IEndpoint, completion: @escaping (Result<Response, Error>) -> Void) {

        decoder.keyDecodingStrategy = endpoint.keyDecodingStrategy
        print(endpoint.path)
        AF.request(endpoint.path,
                   method: endpoint.method,
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: endpoint.headers).response { [weak self] response in

            guard let self = self else { return }

            let result: Result<Response, Error>

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            guard let httpResponse = response.response else {
                result = Result.failure(APIError.noNetwork)
                return
            }

            if let error = self.validateResponse(httpResponse) {
                result = .failure(error)
                return
            }

            guard let data = response.data else {
                result = Result.failure(RequestError.unknown)
                return
            }

            do {

                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)

                let object = try self.decoder.decode(Response.self, from: data)
                result = Result.success(object)

            } catch {
                print(error)
                result = Result.failure(RequestError.unknown)
            }

        }

    }

    private func validateResponse(_ response: HTTPURLResponse?) -> RequestError? {
        guard let statusCode = response?.statusCode else {
            return .unknown
        }

        switch statusCode {
        case 200...300:     return nil
        case 401:           return .unauthorizedRequest
        case 404:           return .pageNotFound
        default:            return .unexpectedStatusCode(statusCode)
        }
    }
}
