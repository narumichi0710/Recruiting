//
//  RecruitmentClient.swift
//

import Foundation
import ComposableArchitecture


import Foundation
import Combine
import ComposableArchitecture

// MARK: 募集機能APIClient
struct RecruitmentClient {
    var list: (RecruitmentRequest.ListRequest) -> Effect<RecruitmentModel.List, APIError>
    var detail: (RecruitmentRequest.DetailRequest) -> Effect<RecruitmentModel.Detail, APIError>
}

extension RecruitmentClient {
    static let live = RecruitmentClient(
        list: { request in
            request.publisher
                .receive(on: request.scheduler)
                .eraseToEffect()
        },
        detail: { request in
            request.publisher
                .receive(on: request.scheduler)
                .eraseToEffect()
        }
    )
}


enum RecruitmentRequest {

    // MARK: 募集一覧APIリクエスト
    struct ListRequest: APIRequest {
        /// 検索ワード
        let searchWord: String
        /// ページネーションナンバー
        let pageNo: Int
        /// スケジューラー
        var method: HTTPMethodType { .get }
        /// パス
        var path: String { "projects/" }
        /// クエリパラメータ
        var queryParameters: [String : String] {
            ["q": searchWord, "page": "\(pageNo)"]
        }
        /// パブリッシャー
        var publisher: AnyPublisher<RecruitmentModel.List, APIError> {
            request()
        }
    }

    // MARK: 募集詳細APIリクエスト
    struct DetailRequest: APIRequest {
        /// 募集ID
        var id: Int
        /// スケジューラー
        var method: HTTPMethodType { .get }
        /// パス
        var path: String { "projects/\(id)" }
        /// パブリッシャー
        var publisher: AnyPublisher<RecruitmentModel.Detail, APIError> {
            request()
        }
    }
}
