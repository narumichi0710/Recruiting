//
//  RecruitingTests.swift
//
import XCTest
@testable import Recruiting
import ComposableArchitecture

// MARK: 募集機能テストデータ
class RecruitingTests: XCTestCase {

    // MARK: 募集一覧API成功テスト
    func testSucceedRecruitmentContents() {
        // テスト用の依存データ
        let store = TestStore(
            initialState: RecruitmentStore.State(),
            reducer: RecruitmentStore.reducer,
            environment: AppStore.Environment(
                recruitmentClient: RecruitmentClient(
                    list: { request in
                        Effect(value: RecruitmentModel.mockList)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    },
                    detail: { request in
                        Effect(value: RecruitmentModel.mockDetail)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    })
            )
        )
        // 募集一覧取得アクション
        store.send(.getRecruitments)
        // 募集一覧取得アクションによって発生するアクション
        store.receive(.responseRecruitments(.success(RecruitmentModel.mockList))) { response in
            response.recruitments = RecruitmentModel.mockList
            response.errorStatus = Bindable<String>(nil)
        }
    }

    // MARK: 募集一覧レスポンス失敗テスト
    func testFairureRecruitmentContents() {
        // テスト用の依存データ
        let store = TestStore(
            initialState: RecruitmentStore.State(),
            reducer: RecruitmentStore.reducer,
            environment: AppStore.Environment(
                recruitmentClient: RecruitmentClient(
                    list: { request in
                        Effect(error: .serverError)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    },
                    detail: { request in
                        Effect(error: .serverError)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    })
            )
        )
        // 募集詳細取得アクション
        store.send(.getRecruitments)
        // 受け取るアクション
        store.receive(.responseRecruitments(.failure(APIError.serverError))) { response in
            response.recruitments = nil
            response.errorStatus = Bindable<String>(APIError.serverError.localize)
        }
    }

    // MARK: 募集詳細レスポンス成功テスト
    func testSucceedRecruitmentDetail() {
        // テスト用の依存データ
        let store = TestStore(
            initialState: RecruitmentStore.State(),
            reducer: RecruitmentStore.reducer,
            environment: AppStore.Environment(
                recruitmentClient: RecruitmentClient(
                    list: { request in
                        Effect(value: RecruitmentModel.mockList)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    },
                    detail: { request in
                        Effect(value: RecruitmentModel.mockDetail)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    })
            )
        )
        // セル選択アクション
        store.send(.presentRecDetail(RecruitmentModel.mockCell_1)) { store in
            store.selectedCell = Bindable<RecruitmentModel.Cell>(RecruitmentModel.mockCell_1)
        }
        // 募集詳細取得アクション
        store.send(.getRecruitmentDetail)
        // 受け取るアクション
        store.receive(.responseRecruitmentDetail(.success(RecruitmentModel.mockDetail))) { response in
            response.recruitmentsDetail = RecruitmentModel.mockDetail
            response.errorStatus = Bindable<String>(nil)
        }
    }

    // MARK: 募集詳細レスポンス失敗テスト
    func testFairureRecruitmentDetail() {
        // テスト用の依存データ
        let store = TestStore(
            initialState: RecruitmentStore.State(),
            reducer: RecruitmentStore.reducer,
            environment: AppStore.Environment(
                recruitmentClient: RecruitmentClient(
                    list: { request in
                        Effect(error: .serverError)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    },
                    detail: { request in
                        Effect(error: .serverError)
                            .receive(on: DispatchQueue.immediate.eraseToAnyScheduler())
                            .eraseToEffect()
                    })
            )
        )
        // セル選択アクション
        store.send(.presentRecDetail(RecruitmentModel.mockCell_1)) { store in
            store.selectedCell = Bindable<RecruitmentModel.Cell>(RecruitmentModel.mockCell_1)
        }
        // 募集詳細取得アクション
        store.send(.getRecruitmentDetail)
        // 受け取るアクション
        store.receive(.responseRecruitmentDetail(.failure(APIError.serverError))) { response in
            response.errorStatus = Bindable<String>(APIError.serverError.localize)
        }
    }
}
