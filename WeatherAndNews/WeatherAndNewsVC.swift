//
//  ViewController.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/20.
//

import UIKit

class WeatherAndNewsVC: UIViewController {

	//MARK: - properties ============================================
	let deviceHalfHeight = UIScreen.main.bounds.height / 2.0

	@IBOutlet weak var CityNameStackView: UIStackView! {
		didSet {
			CityNameStackView.layoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
			CityNameStackView.isLayoutMarginsRelativeArrangement = true
		}
	}
	@IBOutlet weak var weatherInfoViewBottomConstraint: NSLayoutConstraint!

	//MARK: - lifecycle ============================================
	override func viewDidLoad() {
		super.viewDidLoad()

		// 날씨 정보 stack view bottom constraint 기기 높이 반값 + 10으로 설정
		weatherInfoViewBottomConstraint.constant = deviceHalfHeight + 10
		handleTapCityStackView()
	}

	override func viewDidAppear(_ animated: Bool) {
		setNewsListVC()
	}

	//MARK: - func ============================================
	// 도시 View 탭 이벤트 추가
	func handleTapCityStackView() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(tapCityStackView))

		CityNameStackView.addGestureRecognizer(tap)
	}
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

	//MARK: - selector ============================================
	/// 상단 도시 위치 나타내는 View 탭 시 셀렉터
	@objc func tapCityStackView() {
		print("tapped city name box")
	}

}


//MARK: - UIViewControllerTransitioningDelegate ============================================
extension WeatherAndNewsVC: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return HalfSheetPresentationController(presentedViewController: presented, presenting: presenting)
	}
}
