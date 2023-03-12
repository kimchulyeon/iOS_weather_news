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
	var selectedCityName = "seoul"
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

	//MARK: - 라이프사이클
	override func viewDidLoad() {
		super.viewDidLoad()

		self.configureView()
		self.fetchWeather()
	}

	override func viewDidAppear(_ animated: Bool) {
		configureNewsView()
	}

	//MARK: - 메소드
	func configureView() {
		self.cityNameButton.setTitle(self.citiesKor[0], for: .normal)
		self.weatherInfoViewBottomConstraint.constant = deviceHalfHeight + 20 // 날씨 정보 stack view bottom constraint 기기 높이 반값
	}
	// NewsListVC present
	func configureNewsView() {
		let newsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListVC")
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

	// 상단 도시 이름 버튼 탭
	@IBAction func tapCityName(_ sender: UIButton) {
		let rows = CityList.allCases.map({ $0.rawValue })
		ActionSheetMultipleStringPicker.show(withTitle: "도시 선택", rows: [rows], initialSelection: [0], doneBlock: { _, index, value in
			if let selectedArray = index as? NSArray, let selectedIndex = selectedArray.firstObject as? Int {
				let selectedCity = self.citiesEng[selectedIndex]
				self.handleCitySelect(selectedCity, selectedIndex: selectedIndex)
			}
		}, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
	}
	private func handleCitySelect(_ selectedCity: String, selectedIndex: Int) {
		self.cityNameButton.setTitle(self.citiesKor[selectedIndex], for: .normal)
		self.selectedCityName = selectedCity
		self.fetchWeather()
	}
	private func fetchWeather() {
		UIView.animate(withDuration: 0.5, delay: 0) {
			self.indicatorView.alpha = 1
			self.indicatorView.startAnimating()
			self.weatherInfoStackView.alpha = 0
			self.weatherImage.alpha = 0
		}

		// Bundle.main.infoDictionary로 환경변수 가져오기 (config파일에 선언 => info.plist에 설정 + 프로젝트 info configuration 탭 debug, release)
		let WEATHER_API_KEY = Bundle.main.infoDictionary?["WEATHER_API_KEY"] ?? ""
		let url = "https://api.openweathermap.org/data/2.5/weather?q=\(self.selectedCityName)&appid=\(WEATHER_API_KEY)"
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
}


//MARK: - UIPickerViewDataSource
extension WeatherAndNewsVC: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.citiesEng.count
	}
}

//MARK: - UIPickerViewDelegate
extension WeatherAndNewsVC: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.citiesEng[row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(self.citiesEng[row])
	}
}
