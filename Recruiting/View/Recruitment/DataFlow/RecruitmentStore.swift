//
//  RecruitmentStore.swift
//

import Foundation
import ComposableArchitecture

// MARK: 募集機能Store.
enum RecruitmentStore {
        struct State: Equatable {
            /// パブリッシャーキャンセル用のHash値.
            struct CancelID: Hashable {
                let id = String(describing: State.self)
            }
            /// 検索ワード.
            var searchWord: String = ""
            /// 募集一覧.
            var recruitments: Recruitment.List? = nil
            /// 選択中の募集.
            var selectedCell: Selection = Selection<Recruitment.Cell>(nil)
        }
        enum Action: Equatable {
            /// レスポンス.
            case response(Result<Recruitment.List, APIError>)
            /// 募集一覧取得アクション.
            case getRecruitments
            /// 検索ワード変更アクション.
            case changedSearchWord(String)
            /// 募集詳細画面アクション.
            case presentRecDetail(Recruitment.Cell?)
        }

    static let reducer = Reducer<State, Action, AppStore.Environment> { state, action, env in
            switch action {
            case .response(let result):
                // 募集一覧取得レスポンス.
                switch result {
                case .success(let response):
                    state.recruitments = response
                    return .none
                case .failure(let errorResponse):
                    // TODO:
                    return .none
                }

            case .getRecruitments:
                // 募集一覧取得処理.
                return env.recruitmentClient.recruitments(
                    .init(searchWord: state.searchWord, pageNo: 1)
                )
                .catchToEffect(Action.response)
                .cancellable(id: State.CancelID())

            case .changedSearchWord(let value):
                // 検索ワード更新処理.
                state.searchWord = value
                return .none

            case .presentRecDetail(let selectedCell):
                // 募集詳細画面遷移処理.
                if selectedCell == nil {
                    state.selectedCell = Selection<Recruitment.Cell>(nil)
                } else {
                    state.selectedCell = Selection<Recruitment.Cell>(selectedCell)
                }
                return .none
            }
        }

}
