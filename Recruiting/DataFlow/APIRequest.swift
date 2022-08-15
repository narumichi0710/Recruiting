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
        return URL(string: "https://api.github.com/")!
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
        // TODO: 実装
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


enum APIError: Error, Equatable {
    // TODO: 実装
}
