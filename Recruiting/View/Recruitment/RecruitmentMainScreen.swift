//
//  RecruitmentMainScreen.swift
//

import SwiftUI
import ComposableArchitecture

// MARK: 募集一覧画面
struct RecruitmentMainScreen: View {
    let store: Store<RecruitmentStore.State, RecruitmentStore.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                // ナビゲーション
                navigation(viewStore)
                // コンテンツ
                content(viewStore)
            }
            .onAppear {
                // 募集一覧の取得
                if viewStore.recruitments == nil {
                    viewStore.send(.getRecruitments)
                }
            }
        }
    }

    /// ナビゲーション
    private func navigation(_ viewStore: ViewStore<RecruitmentStore.State, RecruitmentStore.Action>) -> some View {
        NavigationLink("", isActive: viewStore.binding(
            get: \.selectedCell.isSelected,
            send: RecruitmentStore.Action.presentRecDetail(nil)
        )){
            // 募集詳細画面に遷移
            RecruitmentDetailScreen(viewStore: viewStore)
                .navigationBarHidden(true)
        }
    }

    /// コンテント
    private func content(_ viewStore: ViewStore<RecruitmentStore.State, RecruitmentStore.Action>) -> some View {
        VStack {
            // 検索項目
            TextField(
                "キーワード",
                text: viewStore.binding(
                    get: \.searchWord, send: RecruitmentStore.Action.changedSearchWord
                )
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.asciiCapable)
            .padding()

            Spacer()

            // 検索結果リスト
            if let items = viewStore.recruitments?.items {

                ScrollView {
                    VStack {
                        ForEach(items) { cell in
                            RecruitmentCell(cell: cell)
                                .onTapGesture {
                                    viewStore.send(.presentRecDetail(cell))
                                }

                            Divider()
                        }
                    }
                }
            } else {
                Text("検索ワードに一致するユーザーが存在しません。")
            }
        }
    }
}


//struct RecruitmentMainScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RecruitmentMainScreen()
//    }
//}
