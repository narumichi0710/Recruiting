//
//  Selection.swift
//

import Foundation

/// ナビゲーションの引数として利用するための構造体
struct Selection<T>: Equatable {
    /// セル選択フラグ
    var isSelected: Bool = false
    /// 選択中のアイテム
    var selectdItem: T?

    init(_ item: T?) {
        isSelected = item != nil
        selectdItem = item
    }

    static func == (lhs: Selection<T>, rhs: Selection<T>) -> Bool {
        return lhs.isSelected == rhs.isSelected
    }
}
