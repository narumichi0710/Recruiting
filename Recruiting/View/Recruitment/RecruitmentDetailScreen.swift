//
//  RecruitmentDetailScreen.swift
//

import SwiftUI
import ComposableArchitecture

// TODO: 実装
// MARK: 募集詳細画面
struct RecruitmentDetailScreen: View {
    let viewStore: ViewStore<RecruitmentStore.State, RecruitmentStore.Action>

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewStore.send(.presentRecDetail(nil))
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.secondary)
                }
                Spacer()
            }
            .padding()

            ScrollView {
                VStack {
                    // 会社情報セル
                    if let selectedCell = viewStore.selectedCell.item {
                        RecruitmentCell(cell: selectedCell)
                            .padding()
                        Divider()
                    }

                    // 会社詳細
                    if let detail = viewStore.recruitmentsDetail?.item,
                       let whatDescription = detail.whatDescription,
                       let whyDescription = detail.whyDescription,
                       let howDescription = detail.howDescription {

                        Text(whatDescription)
                            .padding()
                        Text(whyDescription)
                            .padding()
                        Text(howDescription)
                            .padding()
                    }
                }
            }
            Spacer()
        }
        .alert(
            viewStore.errorStatus.item ?? "",
            isPresented: viewStore.binding(get: \.errorStatus.flag, send: RecruitmentStore.Action.changeErrorState),
            actions: {}
        )
        .onAppear {
            // 募集詳細データの取得
            viewStore.send(.getRecruitmentDetail)
        }
    }
}

//struct RecruitmentDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RecruitmentDetailScreen()
//    }
//}
