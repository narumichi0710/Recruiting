//
//  RecruitingApp.swift
//

import SwiftUI
import ComposableArchitecture

@main
struct RecruitingApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(
                initialState: AppStore.State(),
                reducer: AppStore.reducer,
                environment: AppStore.Environment(
                    recruitmentClient: .live
                )
            ))
        }
    }
}
