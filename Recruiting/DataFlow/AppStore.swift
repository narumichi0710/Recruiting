//
//  AppStore.swift
//

import SwiftUI
import ComposableArchitecture

// MARK: アプリ全体で管理している.
enum AppStore {

    struct State: Equatable {
        /// ルートタブの状態を管理しているState
        var selectedRootTab: RootTabType = .recruitment
    }

    enum Action: Equatable {
        /// ルートタブ変更アクション
        case changedRootTab(RootTabType)
    }

    struct Environment {
    }

    static let reducer = Reducer<State, Action, Environment> { state, action, env in
        switch action {
        case .changedRootTab(let type):
            state.selectedRootTab = type
            return .none
        }
    }
}
