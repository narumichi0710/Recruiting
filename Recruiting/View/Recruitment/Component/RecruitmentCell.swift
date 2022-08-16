//
//  RecruitmentCell.swift
//
import SwiftUI

// 募集セル
struct RecruitmentCell: View {
    let cell: RecruitmentModel.Cell

    var body: some View {
        VStack(spacing: 8) {
            // 会社写真
            if let image = cell.image?.original, let imageUrl = URL(string: image) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }
            // タイトル
            if let title = cell.title {
                HStack {
                    Text(title)
                        .font(.body)
                    Spacer()
                }
            }

            if let image = cell.company?.avatar?.original, let companyName = cell.company?.name {
                HStack {
                    // 会社アイコン
                    AsyncImage(url: URL(string: image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(Circle())
                    .frame(width: 32, height: 32)

                    // 会社名
                    Text(companyName)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                    Spacer()
                }
            }
        }
        .contentShape(Rectangle())
    }
}
