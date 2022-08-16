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
        var selectedCell: Bindable<RecruitmentModel.Cell> = Bindable(nil)
        /// 表示しているページ
        var currentPageNo: Int = 1
        /// エラーステータス
        var errorStatus: Bindable<String> = Bindable(nil)
        /// 募集一覧取得時のデータ新規作成フラグ
        var isCreateNewRecruitments: Bool = true
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
        /// ページNo.更新アクション
        case updatePageNo
        /// エラーステータス更新アクション
        case changeErrorState
    }

    static let reducer = Reducer<State, Action, AppStore.Environment> { state, action, env in
        switch action {
        case .responseRecruitments(let result):
            // 募集一覧取得レスポンス.
            switch result {
            case .success(let response):
                // 文字検索の場合はデータ差し替え、ページ更新の場合はデータを上書きする.
                if state.isCreateNewRecruitments {
                    state.recruitments = response
                } else {
                    state.recruitments?.items?.append(contentsOf: response.items ?? [])
                    state.recruitments?.metaDeta = response.metaDeta
                }
                return .none
            case .failure(let errorResponse):
                state.errorStatus = Bindable(errorResponse.localize)
                return .none
            }

        case .responseRecruitmentDetail(let result):
            // 募集詳細取得レスポンス.
            switch result {
            case .success(let response):
                state.recruitmentsDetail = response
                return .none
            case .failure(let errorResponse):
                state.errorStatus = Bindable(errorResponse.localize)
                return .none
            }

        case .getRecruitments:
            // 募集一覧取得処理.
            return env.recruitmentClient.list(
                .init(searchWord: state.searchWord, pageNo: state.currentPageNo)
            )
            .catchToEffect(Action.responseRecruitments)
            .cancellable(id: State.CancelID())

        case .getRecruitmentDetail:
            // 募集詳細取得処理.
            guard let cellId = state.selectedCell.item?.id else {
                state.errorStatus = Bindable(APIError.serverError.localize)
                return .none
            }
            return env.recruitmentClient.detail(
                .init(id: cellId)
            )
            .catchToEffect(Action.responseRecruitmentDetail)
            .cancellable(id: State.CancelID())

        case .changedSearchWord(let value):
            // 検索ワード更新処理.
            state.isCreateNewRecruitments = true
            state.searchWord = value
            return .none

        case .presentRecDetail(let selectedCell):
            // 募集詳細画面遷移処理.
            if selectedCell == nil {
                state.selectedCell = Bindable(nil)
            } else {
                state.selectedCell = Bindable(selectedCell)
            }
            return .none

        case .updatePageNo:
            // ページNo更新処理
            if let totalPages = state.recruitments?.metaDeta?.totalPages, totalPages > state.currentPageNo {
                state.isCreateNewRecruitments = false
                state.currentPageNo += 1
                return Effect(value: .getRecruitments).eraseToEffect()
            } else {
                return .none
            }

        case .changeErrorState:
            // エラーステータス更新処理
            state.errorStatus = Bindable(nil)
            return .none
        }
    }
}
