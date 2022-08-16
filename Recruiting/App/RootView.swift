//
//  ContentView.swift
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<AppStore.State, AppStore.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { geo in
                let tabItemWidth = geo.size.width / CGFloat(RootTabType.allCases.count)
                NavigationView {
                    VStack {
                        // コンテント
                        content(viewStore: viewStore)
                        // タブバー
                        tabBar(viewStore: viewStore, tabItemWidth: tabItemWidth)
                    }
                    .navigationBarHidden(true)
                }
            }
        }
    }

    /// コンテント.
    /// - Parameter viewStore: viewStore.
    /// - Returns: View.
    private func content(viewStore: ViewStore<AppStore.State, AppStore.Action>) -> some View {
        VStack {
            // タブコンテント
            switch viewStore.selectedRootTab {
            case .recruitment:
                RecruitmentMainScreen(
                    store: store.scope(
                        state: \.recruitmentState,
                        action: AppStore.Action.recruitment
                    )
                )
            case .messege:
                VStack {
                    Spacer()
                    Text("メッセージ")
                    Spacer()
                }
            case .profile:
                VStack {
                    Spacer()
                    Text("プロフィール")
                    Spacer()
                }
            }
            Spacer()
        }
    }

    /// タブバー.
    /// - Parameters:
    ///   - viewStore: viewStore.
    ///   - tabItemWidth: タブ1つの横幅.
    /// - Returns: View.
    private func tabBar(
        viewStore: ViewStore<AppStore.State, AppStore.Action>,
        tabItemWidth: CGFloat
    ) -> some View {
        HStack(spacing: 0) {
            ForEach(RootTabType.allCases, id: \.self) { type in
                VStack {
                    Image(systemName: type.toIconName)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(viewStore.selectedRootTab == type ? Color.primary : Color.secondary)
                }
                .frame(width: tabItemWidth)
                .contentShape(Rectangle())
                .onTapGesture {
                    // タブの更新処理
                    viewStore.send(.changedRootTab(type), animation: .easeInOut)
                }
            }
        }
        .frame(height: 48)
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
