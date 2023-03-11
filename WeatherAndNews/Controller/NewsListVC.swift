//
//  NewsListVC.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/27.
//

import UIKit

class NewsListVC: UIViewController {
	//MARK: - Properties
	@IBOutlet weak var newsTableView: UITableView! {
		didSet {
			newsTableView.separatorStyle = .none
		}
	}

	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		newsTableView.delegate = self
		newsTableView.dataSource = self

		/*
		 ✅ viewcontroller는 UIStoryboard.instantiateViewController(identifier:)
		 ✅ view는 UINib(nibName:)
		*/
		let nib = UINib(nibName: "NewsTVC", bundle: nil)
		newsTableView.register(nib, forCellReuseIdentifier: "NewsTVC")

		self.configureCornerRadius()
	}

	//MARK: - func ============================================
	/// view의 왼쪽 상단, 오른쪽 상단 cornerRadius 설정
	private func configureCornerRadius() {
		let maskPath = UIBezierPath(roundedRect: self.view.bounds,
		                            byRoundingCorners: [.topLeft, .topRight],
		                            cornerRadii: CGSize(width: 20.0, height: 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.path = maskPath.cgPath
		self.view.layer.mask = maskLayer
	}
}


//MARK: - UITableViewDelegate
extension NewsListVC: UITableViewDelegate {
	
}

//MARK: - UITableViewDataSource
extension NewsListVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTVC", for: indexPath) as? NewsTVC else { return UITableViewCell() }
		cell.titleLabel?.text = "wow"
		return cell
	}
}
