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
            .alert(
                viewStore.errorStatus.item ?? "",
                isPresented: viewStore.binding(get: \.errorStatus.flag, send: RecruitmentStore.Action.changeErrorState),
                actions: {}
            )
            .onAppear {
                // 募集一覧の取得
                viewStore.send(.getRecruitments)
            }
        }
    }

    /// ナビゲーション
    private func navigation(_ viewStore: ViewStore<RecruitmentStore.State, RecruitmentStore.Action>) -> some View {
        NavigationLink("", isActive: viewStore.binding(
            get: \.selectedCell.flag,
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
            ) {
                // 検索結果の取得
                viewStore.send(.getRecruitments)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.asciiCapable)
            .padding()

            Spacer()

            // 検索結果リスト
            if let recruitments = viewStore.recruitments {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        HStack {
                            Spacer()
                            Text("検索結果: \(recruitments.metaDeta.totalObjects)件")
                                .font(.subheadline)
                                .foregroundColor(Color.secondary)
                                .padding(.horizontal)
                        }
                        ForEach(recruitments.items) { cell in
                            RecruitmentCell(cell: cell)
                                .padding()
                                .onAppear {
                                    if recruitments.items.last?.id == cell.id {
                                        // 次のページの読み込み処理
                                        viewStore.send(.updatePageNo)
                                    }
                                }
                                .onTapGesture {
                                    viewStore.send(.presentRecDetail(cell))
                                }
                            Divider()
                        }
                    }
                    .refreshable {
                        viewStore.send(.getRecruitments)
                    }
                }
            } else {
                ProgressView()
                Spacer()
            }
        }
    }
}


//struct RecruitmentMainScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RecruitmentMainScreen()
//    }
//}
