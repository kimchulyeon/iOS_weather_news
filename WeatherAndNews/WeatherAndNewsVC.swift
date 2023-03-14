//
//  ViewController.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/20.
//

import UIKit
import ActionSheetPicker_3_0
import Alamofire

class WeatherAndNewsVC: UIViewController {
	let deviceHalfHeight = UIScreen.main.bounds.height / 2.0
	@IBOutlet weak var weatherInfoViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var cityNameButton: UIButton!
	@IBOutlet weak var rainLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var dustLabel: UILabel!

	var selectedKorCityName = "서울"
	var selectedEngCityName = "seoul"

	// 도시 영문명 배열
	var citiesEng = CityList.allCases.map { city in
		var cityString = "\(city)"
		if cityString.contains("_") {
			let replacedCityString = cityString.replacingOccurrences(of: "_", with: "-")
			return replacedCityString
		}
		return cityString
	}
	// 도시 한글명 배열
	var citiesKor = CityList.allCases.map({ city in
		return city.rawValue
	})

	@IBOutlet weak var indicatorView: UIActivityIndicatorView!
	@IBOutlet weak var weatherImage: UIImageView!
	@IBOutlet weak var weatherInfoStackView: UIStackView!

	var newsList: [Article]?
	var newCategory: NewsCategory = .general


	//MARK: - 라이프사이클
	override func viewDidLoad() {
		super.viewDidLoad()

		self.fetchNews()
		if UserDefaults.standard.string(forKey: "selectedCity") == nil {
			self.configureView()
			self.fetchWeather()
			self.fetchDust()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.bringCityNameFromUserDefaults()
	}

	//MARK: - 메소드
	/// 상단 도시 버튼 텍스트 지정, 날씨 정보 뷰 bottom 패딩 값
	func configureView() {
		guard let engNameIndex = self.citiesEng.firstIndex(of: self.selectedEngCityName) else { return }
		self.selectedKorCityName = self.citiesKor[engNameIndex]
		self.cityNameButton.setTitle(self.selectedKorCityName, for: .normal)
		self.weatherInfoViewBottomConstraint.constant = deviceHalfHeight + 20 // 날씨 정보 stack view bottom constraint 기기 높이 반값
	}
	/// 아래 draggable한 뉴스리스트 뷰 구성
	func configureNewsView() {
		guard let newsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListVC") as? NewsListVC else { return }
		newsVC.delegate = self
		newsVC.newsList = self.newsList
		// false면 모달 사라지게 가능 | true면 항상 떠있게 하기
		newsVC.isModalInPresentation = true

		// sheetPresentationController는 iOS 15이상만 지원한다
		if let sheet = newsVC.sheetPresentationController {
			sheet.detents = [.medium(), .large()] // sheet가 머물 수 있는 곳?
			sheet.largestUndimmedDetentIdentifier = .medium // medium 이상일 때 dim처리를 하지 않는다 (modal backdrop)
			sheet.prefersScrollingExpandsWhenScrolledToEdge = true // true일 때 모달 안에 table view가 있으면 table view 스크롤보다 모달 확장을 우선
			sheet.prefersGrabberVisible = true // grabber 막대기 표시
		}
		self.present(newsVC, animated: true)

	}

	/// 상단 도시 이름 버튼 탭
	@IBAction func tapCityName(_ sender: UIButton) {
		let rows = CityList.allCases.map({ $0.rawValue })
		ActionSheetMultipleStringPicker.show(withTitle: "도시 선택", rows: [rows], initialSelection: [0], doneBlock: { _, index, value in
			if let selectedArray = index as? NSArray, let selectedIndex = selectedArray.firstObject as? Int {
				let selectedCity = self.citiesEng[selectedIndex]
				self.selectedKorCityName = self.citiesKor[selectedIndex]
				self.handleCitySelect(selectedCity, selectedIndex: selectedIndex)
			}
		}, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
	}
	/// UserDefaults에 도시명이 저장되어있다면 가져와서 뷰를 구성하고 날씨 api 호출
	private func bringCityNameFromUserDefaults() {
		guard let cityName = UserDefaults.standard.string(forKey: "selectedCity") else { return }
		self.selectedEngCityName = cityName
		self.configureView()
		self.fetchWeather()
		self.fetchDust()
	}
	/// 상단 도시 선택 시 UserDefaults 도시 저장하고 날씨 api 호출
	private func handleCitySelect(_ selectedCity: String, selectedIndex: Int) {
		self.cityNameButton.setTitle(self.citiesKor[selectedIndex], for: .normal)
		self.selectedEngCityName = selectedCity
		UserDefaults.standard.set(selectedCity, forKey: "selectedCity")
		self.fetchWeather()
		self.fetchDust()
	}
	/// 날씨 api 호출
	private func fetchWeather() {
		UIView.animate(withDuration: 0.5, delay: 0) {
			self.indicatorView.alpha = 1
			self.indicatorView.startAnimating()
			self.weatherInfoStackView.alpha = 0
			self.weatherImage.alpha = 0
		}

		// Bundle.main.infoDictionary로 환경변수 가져오기 (config파일에 선언 => info.plist에 설정 + 프로젝트 info configuration 탭 debug, release)
		let WEATHER_API_KEY = Bundle.main.infoDictionary?["WEATHER_API_KEY"] ?? ""
		let url = "https://api.openweathermap.org/data/2.5/weather?q=\(self.selectedEngCityName)&appid=\(WEATHER_API_KEY)"
		AF.request(url).response { response in
			switch response.result {
			case let .success(value):
				let decoder = JSONDecoder()
				do {
					guard let data = value else { return }
					let weatherData = try decoder.decode(WeatherInfo.self, from: data)

					let temp = weatherData.temp.temp - 273.15
					DispatchQueue.main.async {
						UIView.animate(withDuration: 0.5, delay: 0) {
							let temperatureText = String(format: "%.0f", temp) + "℃"
							self.tempLabel.text = temperatureText
							if let rain = weatherData.rain {
								// 비 올 때
								self.rainLabel.text = rain.duringOneHour.description + "mm"
							} else if let snow = weatherData.snow {
								self.rainLabel.text = snow.duringOneHour.description + "mm"
							} else {
								self.rainLabel.text = "0mm"
							}


							self.indicatorView.stopAnimating()
							self.indicatorView.alpha = 0
							self.weatherImage.alpha = 1
							self.weatherInfoStackView.alpha = 1
						}
					}
				} catch {
					print(error)
				}

			case let .failure(error):
				print(error)
			}
		}
	}
	/// 미세먼지 api 호출
	private func fetchDust() {
		let DUST_API_KEY = Bundle.main.infoDictionary?["DUST_API_KEY"] ?? ""
		let url = "https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey=\(DUST_API_KEY)&returnType=json&numOfRows=1&pageNo=1&ver=1.0"
		let parameter = ["sidoName": self.selectedKorCityName]
		AF.request(url, parameters: parameter).response { response in
			switch response.result {
			case let .success(value):
				let decoder = JSONDecoder()
				do {
					guard let value = value else { return }
					let dustData = try decoder.decode(Dust.self, from: value)
					self.dustLabel.text = dustData.response.body.items[0].grade
					switch self.dustLabel.text {
					case "좋음":
						// rgb(52, 152, 219)
						self.dustLabel.textColor = UIColor(red: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 1)
					case "보통":
						// rgba(72, 84, 96,1.0)
						self.dustLabel.textColor = .brown
					case "나쁨":
						// rgb(211, 84, 0)
						self.dustLabel.textColor = UIColor(red: 211 / 255, green: 84 / 255, blue: 0 / 255, alpha: 1)
					case "매우나쁨":
						// rgb(192, 57, 43)
						self.dustLabel.textColor = UIColor(red: 192 / 255, green: 57 / 255, blue: 43 / 255, alpha: 1)
					default:
						self.dustLabel.textColor = .black
					}
				} catch {
					print(error)
				}
			case let .failure(error):
				print(error)
			}
		}
	}
	/// 뉴스 api 호출
	private func fetchNews() {
		let NEWS_API_KEY = Bundle.main.infoDictionary?["NEWS_API_KEY"] ?? ""
		let url = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=\(NEWS_API_KEY)&pageSize=10&page=1&category=\(self.newCategory)"

		AF.request(url).response { response in
			switch response.result {
			case let .success(data):
				let decoder = JSONDecoder()
				do {
					guard let data = data else { return }
					let newsData = try decoder.decode(News.self, from: data)
					self.newsList = newsData.articles
					self.configureNewsView()
				} catch {
					print(error)
				}
			case let .failure(error):
				print(error)
			}
		}
	}

	// https://newsapi.org/v2/top-headlines?country=kr&apiKey=283ee2e3a7104bd681733595977634a3&pageSize=10&page=2 // 인기
	// https://newsapi.org/v2/top-headlines?country=kr&category=sports&apiKey=283ee2e3a7104bd681733595977634a3&pageSize=10&page=2 // 스포츠
	// https://newsapi.org/v2/top-headlines?country=kr&category=entertainment&apiKey=283ee2e3a7104bd681733595977634a3&pageSize=10&page=2 // 연예

}


extension WeatherAndNewsVC: NewsListDelegate {
	func tapCategory(value: NewsCategory) {
		self.newCategory = value
		self.fetchNews()
	}
}
