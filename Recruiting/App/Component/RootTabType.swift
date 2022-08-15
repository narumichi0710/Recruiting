//
//  RootTabType.swift
//

import Foundation

/// ルートタブタイプ
enum RootTabType: Int, CaseIterable {
    case recruitment
    case search
    case profile

    var localize: String {
        switch self {
        case .recruitment:
            return "募集"
        case .search:
            return "検索"
        case .profile:
            return "マイページ"
        }
    }
}
