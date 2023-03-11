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
	var cities = CityList.allCases.map { city in
		var cityString = "\(city)"
		if cityString.contains("_") {
			let replacedCityString = cityString.replacingOccurrences(of: "_", with: "-")
			return replacedCityString
		}
		return cityString
	}

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
		self.cityNameButton.setTitle(selectedCityName, for: .normal)
		self.weatherInfoViewBottomConstraint.constant = deviceHalfHeight + 20 // 날씨 정보 stack view bottom constraint 기기 높이 반값
	}
	// NewsListVC present
	func configureNewsView() {
		let newsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListVC")
		// false면 모달 사라지게 가능 | true면 항상 떠있게 하기
		newsVC.isModalInPresentation = true

		// sheetPresentationController는 iOS 15이상만 지원한다
		if #available(iOS 15.0, *) {
			if let sheet = newsVC.sheetPresentationController {
				sheet.detents = [.medium(), .large()] // sheet가 머물 수 있는 곳?
				sheet.largestUndimmedDetentIdentifier = .medium // medium 이상일 때 dim처리를 하지 않는다 (modal backdrop)
				sheet.prefersScrollingExpandsWhenScrolledToEdge = true // true일 때 모달 안에 table view가 있으면 table view 스크롤보다 모달 확장을 우선
				sheet.prefersGrabberVisible = true // grabber 막대기 표시
			}
			self.present(newsVC, animated: true)

			// iOS 15 미만일 경우
		} else {
			let newsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsListVC")
			newsVC.modalPresentationStyle = .custom
			newsVC.transitioningDelegate = self
			present(newsVC, animated: true, completion: nil)
		}

	}

	// 상단 도시 이름 버튼 탭
	@IBAction func tapCityName(_ sender: UIButton) {
		let rows = CityList.allCases.map({ $0.rawValue })
		ActionSheetMultipleStringPicker.show(withTitle: "도시 선택", rows: [rows], initialSelection: [0], doneBlock: { _, index, value in
			if let selectedArray = index as? NSArray, let selectedIndex = selectedArray.firstObject as? Int {
				let selectedCity = self.cities[selectedIndex]
				self.handleCitySelect(selectedCity)
			}
		}, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
	}
	private func handleCitySelect(_ selectedCity: String) {
		self.cityNameButton.setTitle(selectedCity, for: .normal)
		self.selectedCityName = selectedCity
		self.fetchWeather()
	}
	private func fetchWeather() {
		let WEATHER_API_KEY = Bundle.main.infoDictionary?["WEATHER_API_KEY"] ?? ""
		let url = "https://api.openweathermap.org/data/2.5/weather?q=\(self.selectedCityName)&appid=\(WEATHER_API_KEY)"
		AF.request(url).response { response in
			switch response.result {
			case let .success(value):
				print("✅")
				let decoder = JSONDecoder()
				do {
					print("do:::::::::::")
					guard let data = value else { return }
					print("guard after::::::::::::::")
					let weatherData = try decoder.decode(WeatherInfo.self, from: data)
					
					if let rain = weatherData.rain {
						print(rain)
					}
					let temp = weatherData.temp.temp - 273.15
					DispatchQueue.main.async {
						let temperatureText = String(format: "%.0f", temp) + "℃"
						self.tempLabel.text = temperatureText
						print(String(format: "%.2f", temp))
						print(weatherData.weather[0].main)
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


//MARK: - UIViewControllerTransitioningDelegate ============================================
extension WeatherAndNewsVC: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return HalfSheetPresentationController(presentedViewController: presented, presenting: presenting)
	}
}

//MARK: - UIPickerViewDataSource
extension WeatherAndNewsVC: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.cities.count
	}
}

//MARK: - UIPickerViewDelegate
extension WeatherAndNewsVC: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.cities[row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(self.cities[row])
	}
}
