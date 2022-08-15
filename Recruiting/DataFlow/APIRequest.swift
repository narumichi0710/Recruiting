//
//  APIRequest.swift
//

import Foundation
import Combine
import ComposableArchitecture

// MARK: API共通処理を継承するためのインターフェイス
protocol APIRequest {
    /// レスポンス
    associatedtype Response: Decodable
    /// URL
    var baseURL: URL { get }
    /// APIパス
    var path: String { get }
    /// HTTPメソッド
    var method: HTTPMethodType { get }
    /// ヘッダーフィールド
    var headerFields: [String: String] { get }
    /// クエリパラメータ
    var queryParameters: [String: String] { get }
    /// パブリッシャー
    var publisher: AnyPublisher<Response, APIError> { get }
    /// スケジューラー
    var scheduler: DispatchQueue { get }
}

extension APIRequest {
    var baseURL: URL {
        return URL(string: "https://www.wantedly.com/api/v1/")!
    }
    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }
    var queryParameters: [String: String] {
        return [:]
    }
    var scheduler: DispatchQueue {
        .main
    }
}


extension APIRequest {

    /// API呼び出し処理
    func request() -> AnyPublisher<Response, APIError> {
        let urlRequest = try! getUrlRequest()

        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse else {
                    throw APIError.noResponse
                }

                guard 200 ..< 300 ~= response.statusCode else {
                    let message = try? JSONDecoder().decode(APIError.Message.self, from: element.data)
                    throw APIError.unacceptableStatusCode(response.statusCode, message)
                }

                return element.data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError(mapError)
            .eraseToAnyPublisher()
    }

    /// urlRequestの生成処理
    /// - Returns: URLRequest
    func getUrlRequest() throws -> URLRequest {
        // Pathの追加
        let url = baseURL.appendingPathComponent(path)

        // urlComponentの生成
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.failedToCreateComponents(url)
        }

        // クエリパラメータの追加
        component.queryItems = queryParameters.compactMap {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }

        // urlRequestの生成
        guard var urlRequest = component.url.map({ URLRequest(url: $0) }) else {
            throw APIError.failedToCreateURL(component)
        }
        urlRequest.httpMethod = method.localize
        urlRequest.allHTTPHeaderFields = headerFields

        return urlRequest
    }

    func mapError(error: Error) -> APIError {
        return error as? APIError ?? .other("TODO:")
    }
}

// MARK: HTTPメソッドタイプ
enum HTTPMethodType: String {
    case get
    case post
    case put
    case delete
    case paych

    var localize: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .paych:
            return "PATCH"
        }
    }
}


// MARK: APIError
enum APIError: Error, Equatable {
    case failedToCreateComponents(URL)
    case failedToCreateURL(URLComponents)
    case noResponse
    case unacceptableStatusCode(Int, Message?)
    case parserError(String)
    case other(String)
}

extension APIError {
    struct Message: Decodable, Equatable {
        let documentationURL: URL
        let errors: Errors
        let message: String

        struct Errors: Decodable, Equatable {
            let resource: String
            let field: String
            let code: String

            private enum CodingKeys: String, CodingKey {
                case resource, field, code
            }
        }

        private enum CodingKeys: String, CodingKey {
            case documentationURL = "documentation_url"
            case errors, message
        }
    }
}
