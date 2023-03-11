//
//  City.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/03/11.
//

import Foundation

struct City: Codable {
	let name, country: String
}

enum CityList: String, CaseIterable {
	case Seoul = "서울"
	case Daejeon = "대전"
	case Busan = "부산"
	case Daegu = "대구"
	case Gwangju = "광주"
	case Jeju = "제주도"
	case Gyeonggido = "경기도"
	case Chungcheongnamdo = "충청남도"
	case Chungcheongbukdo = "충청북도"
	case Gangwondo = "강원도"
	case Jeollanamdo = "전라남도"
	case Jeollabukdo = "전라북도"
	case Gyeongsangbukdo = "경상북도"
	case Gyeongsangnamdo = "경상남도"
}
