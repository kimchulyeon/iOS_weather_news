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
	case Gyeonggi_do = "경기도"
	case Chungcheongnam_do = "충청남도"
	case Chungcheongbuk_do = "충청북도"
	case Gangwon_do = "강원도"
	case Jeollanam_do = "전라남도"
	case Jeollabuk_do = "전라북도"
	case Gyeongsangbuk_do = "경상북도"
	case Gyeongsangnam_do = "경상남도"
}
