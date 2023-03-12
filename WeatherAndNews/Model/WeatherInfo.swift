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
	let snow: Snow?
	
	enum CodingKeys: String, CodingKey {
		case weather
		case temp = "main"
		case rain, snow
	}
}

struct Weather: Codable {
	let main: String
}

struct Temp: Codable {
	let temp: Double
}

struct Rain: Codable {
	let duringOneHour: Double
	
	enum CodingKeys: String, CodingKey {
		case duringOneHour = "1h"
	}
}

struct Snow: Codable {
	let duringOneHour: Double
	
	enum CodingKeys: String, CodingKey {
		case duringOneHour = "1h"
	}
}
