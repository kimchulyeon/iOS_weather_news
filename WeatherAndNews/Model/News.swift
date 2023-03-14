//
//  News.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/03/14.
//

import Foundation

// MARK: - Welcome
struct News: Codable {
	let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
	let author, title: String
	let url: URL
	let publishedAt: String
}
