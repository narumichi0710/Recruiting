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
                NavigationView {
                    ZStack {
                        // コンテント
                        content(viewStore: viewStore, viewSize: geo.size)
                    }
                    .navigationBarHidden(true)
                }
            }
        }
    }

    /// コンテント
    private func content(
        viewStore: ViewStore<AppStore.State, AppStore.Action>,
        viewSize: CGSize
    ) -> some View {
        VStack {
            /// タブコンテント
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

            // タブバー
            tabBar(
                viewStore: viewStore,
                tabItemWidth: viewSize.width / CGFloat(RootTabType.allCases.count)
            )
        }
    }


    /// タブバー.
    private func tabBar(
        viewStore: ViewStore<AppStore.State, AppStore.Action>,
        tabItemWidth: CGFloat
    ) -> some View {
        HStack(spacing: 0) {
            ForEach(RootTabType.allCases, id: \.self) { type in
                Image(systemName: type.toIconName)
                    .foregroundColor(viewStore.selectedRootTab == type ? Color.primary : Color.secondary)
                    .frame(width: tabItemWidth, height: 48)
                    .onTapGesture {
                        viewStore.send(.changedRootTab(type), animation: .default)
                    }
            }
            Spacer()
        }
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
