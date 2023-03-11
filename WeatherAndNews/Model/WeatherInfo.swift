//
//  WeatherInfo.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/03/11.
//

import Foundation

struct WeatherInfo: Codable {
	let weather: [Weather]
	let temp: Temp
	let rain: Rain
	
	enum CodingKeys: String, CodingKey {
		case weather, rain
		case temp = "main"
	}
}

struct Weather: Codable {
	let main: String
}

struct Temp: Codable {
	let temp: String
}

struct Rain: Codable {
	let perOneHour: Double
	
	enum CodingKeys: String, CodingKey {
		case perOneHour = "1h"
	}
}
