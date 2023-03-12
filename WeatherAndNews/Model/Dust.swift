//
//  Dust.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/03/12.
//

import Foundation

// MARK: - Welcome
struct Dust: Codable {
	let response: Response
}

// MARK: - Response
struct Response: Codable {
	let body: Body
}

// MARK: - Body
struct Body: Codable {
	let items: [Item]
}

// MARK: - Item
struct Item: Codable {
	let informGrade: String
}
