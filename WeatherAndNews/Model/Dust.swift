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
	let items: [DustValue]
}

// MARK: - Item
struct DustValue: Codable {
	let pm10Value, pm10Grade: String
	
	var grade: String {
		switch pm10Grade {
		case "1":
			return "좋음"
		case "2":
			return "보통"
		case "3":
			return "나쁨"
		case "4":
			return "매우나쁨"
		default:
			return "알 수 없음"
		}
	}
	
//	enum CodingKeys: String, CodingKey {
//		case value = "pm10Value" // "45"
//		case grade = "pm10Grade" // "2"      1: 좋음 2: 보통 3: 나쁨 4: 매우나쁨
//	}
}

