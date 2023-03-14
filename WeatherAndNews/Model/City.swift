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
	case Jeju = "제주"
	case Gyeonggi_do = "경기"
	case Chungcheongnam_do = "충남"
	case Chungcheongbuk_do = "충북"
	case Gangwon_do = "강원"
	case Jeollanam_do = "전남"
	case Jeollabuk_do = "전북"
	case Gyeongsangbuk_do = "경북"
	case Gyeongsangnam_do = "경남"
}
