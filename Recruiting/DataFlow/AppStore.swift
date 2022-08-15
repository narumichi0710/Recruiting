//
//  AppStore.swift
//

import SwiftUI
import ComposableArchitecture

// MARK: アプリ全体で管理している.
enum AppStore {

    struct State: Equatable {
    }

    enum Action: Equatable {
    }

    struct Environment {
    }

    static let reducer = Reducer<State, Action, Environment> { state, action, env in
        switch action {
        default: return .none
        }
    }
}
