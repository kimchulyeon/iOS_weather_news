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
	let rain: Rain?
	
	enum CodingKeys: String, CodingKey {
		case weather
		case temp = "main"
		case rain
	}
}

struct Weather: Codable {
	let main: String
}

struct Temp: Codable {
	let temp: Double
}

struct Rain: Codable {
	let perOneHour: Double
	
	enum CodingKeys: String, CodingKey {
		case perOneHour = "1h"
	}
}
