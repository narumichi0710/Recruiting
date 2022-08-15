//
//  Recruitments.swift
//

import Foundation
import ComposableArchitecture

// MARK: 募集機能
enum RecruitmentModel {}

// MARK: 募集一覧APIモデル
extension RecruitmentModel {

    struct List: Decodable, Equatable {
        var metaDeta: Meta
        var items: [Cell]

        private enum CodingKeys: String, CodingKey {
            case metaDeta = "_metadata"
            case items = "data"
        }
    }

    struct Meta: Decodable, Equatable {
        var totalObjects: Int
        var perPage: Int
        var totalPages: Int

        private enum CodingKeys: String, CodingKey {
            case totalObjects = "total_objects"
            case perPage = "per_page"
            case totalPages = "total_pages"
        }
    }

    struct Cell: Decodable, Equatable, Identifiable{
        var id: Int
        var title: String
        var company: Company
        var image: Image
    }

    struct Company: Decodable, Equatable {
        var name: String
        var avatar: Image
    }

    struct Image: Decodable, Equatable {
        var original: String
    }
}


// MARK: 募集詳細APIモデル
extension RecruitmentModel {
    struct Detail: Decodable, Equatable {
        var item: Data

        struct Data: Decodable, Equatable {
            var title: String
            var company: Company
            var image: Image
            var whatDescription: String
            var whyDescription: String
            var howDescription: String

            private enum CodingKeys: String, CodingKey {
                case title, company, image
                case whatDescription = "what_description"
                case whyDescription = "why_description"
                case howDescription = "how_description"
            }
        }

        private enum CodingKeys: String, CodingKey {
            case item = "data"
        }
    }
}



extension RecruitmentModel {
    // MARK: 募集一覧モックデータ
    static let mockList = List(
        metaDeta: Meta(totalObjects: 100, perPage: 20, totalPages: 10),
        items: [
            Cell(
                id: 1, title: "sample1",
                company: Company(
                    name: "sampleCompany1",
                    avatar: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/7052304/original/49100b17-5866-4cec-b50b-a37ea73565e9?1638782149")
                ),
                image: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/5514165/original/43e51376-db16-4eb3-88fd-de8ead793416?1654489801")
            ),
            Cell(
                id: 2, title: "sample2",
                company: Company(
                    name: "sampleCompany1",
                    avatar: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/7052304/original/49100b17-5866-4cec-b50b-a37ea73565e9?1638782149")
                ),
                image: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/1843922/original/9d40990d-65aa-4dda-9a2b-2667f7ea373a?1507811728")
            ),
            Cell(
                id: 3, title: "sample3",
                company: Company(
                    name: "sampleCompany1",
                    avatar: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/7052304/original/49100b17-5866-4cec-b50b-a37ea73565e9?1638782149")
                ),
                image: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/5634663/original/b612c8fa-a7b9-4e3a-9a48-5d6f7fb3bbcf?1658905562")
            )
        ]
    )
    // MARK: 募集詳細モックデータ
    static let mockDetail = Detail(
        item: Detail.Data(
            title: "sample1",
            company: Company(
                name: "sampleCompany1",
                avatar: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/7052304/original/49100b17-5866-4cec-b50b-a37ea73565e9?1638782149")
            ),
            image: Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/5514165/original/43e51376-db16-4eb3-88fd-de8ead793416?1654489801"),
            whatDescription: "sampleWhatDescription",
            whyDescription: "sampleWhyDescription",
            howDescription: "sampleHowDescription"
        )
    )
}
