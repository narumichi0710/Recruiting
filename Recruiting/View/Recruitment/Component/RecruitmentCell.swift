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
            if let image = cell.image.original {
                AsyncImage(url: URL(string: image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
            }
            // タイトル
            HStack {
                Text(cell.title)
                    .font(.body)
                Spacer()
            }

            if let image = cell.company.avatar.original {
                HStack {
                    // サムネイル
                    AsyncImage(url: URL(string: image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(Circle())
                    .frame(width: 32, height: 32)

                    // 会社名
                    Text(cell.company.name)
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)

                    Spacer()
                }
            }
        }
        .padding()
        .contentShape(Rectangle())
    }
}
