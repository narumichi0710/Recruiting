//
//  Recruitments.swift
//

import Foundation
import ComposableArchitecture

// MARK: 募集一覧 APIModel
struct Recruitments: Decodable, Equatable {
    var metaDeta: MetaData
    var items: [Recruitment]

    private enum CodingKeys: String, CodingKey {
        case metaDeta = "_metadata"
        case items = "data"
    }

    static let mockRecruitments = Recruitments(
        metaDeta: MetaData(totalObjects: 100, perPage: 20, totalPages: 10),
        items: [
            Recruitment(
                id: 1, title: "sample1", company: Recruitment.Company(name: "sampleCompany1"),
                image: Recruitment.Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/5514165/original/43e51376-db16-4eb3-88fd-de8ead793416?1654489801")
            ),
            Recruitment(
                id: 2, title: "sample2", company: Recruitment.Company(name: "sampleCompany2"),
                image: Recruitment.Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/1843922/original/9d40990d-65aa-4dda-9a2b-2667f7ea373a?1507811728")
            ),
            Recruitment(
                id: 3, title: "sample3", company: Recruitment.Company(name: "sampleCompany3"),
                image: Recruitment.Image(original: "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/5634663/original/b612c8fa-a7b9-4e3a-9a48-5d6f7fb3bbcf?1658905562")
            )
        ]
    )
}

struct MetaData: Decodable, Equatable {
    var totalObjects: Int
    var perPage: Int
    var totalPages: Int

    private enum CodingKeys: String, CodingKey {
        case totalObjects = "total_objects"
        case perPage = "per_page"
        case totalPages = "total_pages"
    }
}

struct Recruitment: Decodable, Equatable, Identifiable{
    var id: Int
    var title: String
    var company: Company
    var image: Image

    struct Company: Decodable, Equatable {
        var name: String
    }

    struct Image: Decodable, Equatable {
        var original: String
    }
}
