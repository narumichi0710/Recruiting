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
    var recruitments: (RecruitmentRequest) -> Effect<Recruitment.List, APIError>
}

extension RecruitmentClient {
    static let live = RecruitmentClient(recruitments: { request in
        request.publisher
            .receive(on: request.scheduler)
            .eraseToEffect()
    })
}

struct RecruitmentRequest: APIRequest {
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
    var publisher: AnyPublisher<Recruitment.List, APIError> {
        request()
    }
}
