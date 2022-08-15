//
//  RecruitmentCell.swift
//
import SwiftUI

// TODO: 後でUI修正
// 募集セル
struct RecruitmentCell: View {
    let cell: Recruitment

    var body: some View {
        HStack {
            // 会社写真
            if let image = cell.image.original {
                AsyncImage(url: URL(string: image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .padding()
            }
            Spacer()

            // 会社情報
            VStack {
                Text(cell.title)
                    .padding()

                Text(cell.company.name)
                    .padding()
            }
        }
        .contentShape(Rectangle())
    }
}
