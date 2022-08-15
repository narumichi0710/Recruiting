//
//  ContentView.swift
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<AppStore.State, AppStore.Action>

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
