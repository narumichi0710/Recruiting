//
//  RootTabType.swift
//

import Foundation

/// ルートタブタイプ
enum RootTabType: Int, CaseIterable {
    case recruitment
    case messege
    case profile

    var localize: String {
        switch self {
        case .recruitment:
            return "募集"
        case .messege:
            return "メッセージ"
        case .profile:
            return "マイページ"
        }
    }
    var toIconName: String {
        switch self {
        case .recruitment:
            return "magnifyingglass"
        case .messege:
            return "message"
        case .profile:
            return "person.crop.circle"
        }
    }
}
