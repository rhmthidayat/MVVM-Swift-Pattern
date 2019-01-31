//
//  NewsModel.swift
//  mvvm
//
//  Created by Rahmat Hidayat on 29/01/19.
//  Copyright © 2019 Rahmat. All rights reserved.
//

import Foundation

struct News: Codable {
    let status, source, sortBy: String?
    let articles: [Article]?
}

struct Article: Codable {
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}
