//
//  AppStore.swift
//

import SwiftUI
import ComposableArchitecture

// MARK: アプリ全体で管理しているStore.
enum AppStore {

    struct State: Equatable {
        /// ルートタブ
        var selectedRootTab: RootTabType = .recruitment
        /// 募集
        var recruitmentState = RecruitmentStore.State()
    }

    enum Action: Equatable {
        /// ルートタブ変更アクション
        case changedRootTab(RootTabType)
        /// 募集アクション
        case recruitment(RecruitmentStore.Action)
    }

    struct Environment {
        /// 募集クライアント
        let recruitmentClient: RecruitmentClient
    }

    /// アプリコア機能Reducer
    static let coreReducer = Reducer<State, Action, Environment> { state, action, env in
        switch action {
        case .changedRootTab(let type):
            state.selectedRootTab = type
            return .none
        default: return .none
        }
    }

    /// アプリコア機能Reducer, 分割したReducerを統合して監視するためのReducer.
    static let reducer = Reducer<State, Action, Environment>.combine(
        // アプリコアReducer
        coreReducer,
        // 募集機能Reducer
        RecruitmentStore.reducer.pullback(
            state: \State.recruitmentState,
            action: /Action.recruitment,
            environment: {
                .init(recruitmentClient: $0.recruitmentClient)
            }
        )
    )

}
