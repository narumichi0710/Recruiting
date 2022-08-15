//
//  RecruitmentDetailScreen.swift
//

import SwiftUI

// TODO: 実装
// MARK: 募集詳細画面
struct RecruitmentDetailScreen: View {
    /// 選択中の募集
    @Binding var selectedCell: Selection<Recruitment>

    var body: some View {
        VStack {
            Button {
                selectedCell.isSelected.toggle()
            } label: {
                Text("Back")
            }

        }

    }
}

//struct RecruitmentDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        RecruitmentDetailScreen()
//    }
//}
