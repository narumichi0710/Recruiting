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
        ScrollView {
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

                if let detail = viewStore.recruitmentsDetail?.item, let selectedCell = viewStore.selectedCell.selectdItem {

                    RecruitmentCell(cell: selectedCell)
                        .padding()

                    Divider()

                    Text(detail.whatDescription)
                        .padding()
                    Text(detail.whyDescription)
                        .padding()
                    Text(detail.howDescription)
                        .padding()
                }

                Spacer()

            }
        }
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
