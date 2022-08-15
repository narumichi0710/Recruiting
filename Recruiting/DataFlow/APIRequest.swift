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
                // TODO: 後で実装
                return element.data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { data in

                // TODO: 後で実装
                data as! APIError
            }
            .eraseToAnyPublisher()
    }

    /// urlRequestの生成処理
    /// - Returns: URLRequest
    func getUrlRequest() throws -> URLRequest {
        // Pathの追加
        let url = baseURL.appendingPathComponent(path)

        // urlComponentの生成
        guard var component = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw APIError.error
        }

        // クエリパラメータの追加
        component.queryItems = queryParameters.compactMap {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }

        // urlRequestの生成
        guard var urlRequest = component.url.map({ URLRequest(url: $0) }) else {
            throw APIError.error
        }
        urlRequest.httpMethod = method.localize
        urlRequest.allHTTPHeaderFields = headerFields

        return urlRequest
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


// TODO: 後で実装
enum APIError: Error, Equatable {
    case error

    var localizedDescription: String {
        return "error"
    }
}
