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
            var recruitments: RecruitmentModel.List? = nil
            /// 募集詳細.
            var recruitmentsDetail: RecruitmentModel.Detail? = nil
            /// 選択中の募集.
            var selectedCell: Selection = Selection<RecruitmentModel.Cell>(nil)
        }
        enum Action: Equatable {
            /// 募集一覧レスポンス.
            case responseRecruitments(Result<RecruitmentModel.List, APIError>)
            /// 募集詳細レスポンス.
            case responseRecruitmentDetail(Result<RecruitmentModel.Detail, APIError>)
            /// 募集一覧取得アクション.
            case getRecruitments
            /// 募集詳細取得アクション.
            case getRecruitmentDetail
            /// 検索ワード変更アクション.
            case changedSearchWord(String)
            /// 募集詳細画面アクション.
            case presentRecDetail(RecruitmentModel.Cell?)
        }

    static let reducer = Reducer<State, Action, AppStore.Environment> { state, action, env in
            switch action {
            case .responseRecruitments(let result):
                // 募集一覧取得レスポンス.
                switch result {
                case .success(let response):
                    state.recruitments = response
                    return .none
                case .failure(let errorResponse):
                    // TODO:
                    return .none
                }
            case .responseRecruitmentDetail(let result):
                // 募集詳細取得レスポンス.
                switch result {
                case .success(let response):
                    state.recruitmentsDetail = response
                    return .none
                case .failure(let errorResponse):
                    // TODO:
                    return .none
                }
            case .getRecruitments:
                // 募集一覧取得処理.
                return env.recruitmentClient.list(
                    .init(searchWord: state.searchWord, pageNo: 1)
                )
                .catchToEffect(Action.responseRecruitments)
                .cancellable(id: State.CancelID())

            case .getRecruitmentDetail:
                guard let cellId = state.selectedCell.selectdItem?.id else {
                    // TODO:
                    return .none
                }
                // 募集詳細取得処理.
                return env.recruitmentClient.detail(
                    .init(id: cellId)
                )
                .catchToEffect(Action.responseRecruitmentDetail)
                .cancellable(id: State.CancelID())

            case .changedSearchWord(let value):
                // 検索ワード更新処理.
                state.searchWord = value
                return .none

            case .presentRecDetail(let selectedCell):
                // 募集詳細画面遷移処理.
                if selectedCell == nil {
                    state.selectedCell = Selection<RecruitmentModel.Cell>(nil)
                } else {
                    state.selectedCell = Selection<RecruitmentModel.Cell>(selectedCell)
                }
                return .none
            }
        }

}
