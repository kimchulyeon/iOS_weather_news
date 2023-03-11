//
//  ViewController.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/20.
//

import UIKit
import ActionSheetPicker_3_0

class WeatherAndNewsVC: UIViewController {
	let deviceHalfHeight = UIScreen.main.bounds.height / 2.0


	@IBOutlet weak var weatherInfoViewBottomConstraint: NSLayoutConstraint!

	@IBOutlet weak var cityNameButton: UIButton! {
		didSet {
			cityNameButton.setTitle(selectedCityName, for: .normal)
		}
	}
	var selectedCityName = "서울"
	var cities = CityList.allCases


	//MARK: - lifecycle ============================================
	override func viewDidLoad() {
		super.viewDidLoad()

		// 날씨 정보 stack view bottom constraint 기기 높이 반값
		self.weatherInfoViewBottomConstraint.constant = deviceHalfHeight + 20
	}

	override func viewDidAppear(_ animated: Bool) {
		setNewsListVC()
	}

	// 도시 View 탭 이벤트 추가

	// NewsListVC present
	func setNewsListVC() {
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


	@IBAction func tapCityName(_ sender: UIButton) {
		ActionSheetMultipleStringPicker.show(withTitle: "도시 선택", rows: [
			self.cities.map({ $0.rawValue })
		], initialSelection: [0], doneBlock: {
			_, _, value in

			return
		}, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
	}
	func handleCitySelect(_ selectedCity: String) {
		print(selectedCity)
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
		return self.cities[row].rawValue
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(self.cities[row].rawValue)
	}
}
