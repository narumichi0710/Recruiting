//
//  Selection.swift
//

import Foundation

/// ViewのBinding型の引数に対して利用する構造体.
struct Bindable<T>: Equatable {
    /// セル選択フラグ
    var flag: Bool = false
    /// 選択中のアイテム
    var item: T?

    init(_ value: T?) {
        flag = value != nil
        item = value
    }

    static func == (lhs: Bindable<T>, rhs: Bindable<T>) -> Bool {
        return lhs.flag == rhs.flag
    }
}
