//
//  NewsListVC.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/27.
// general sports entertainment technology health business
// https://github.com/Juanpe/SkeletonView

import UIKit
import UIScrollView_InfiniteScroll

enum NewsCategory {
	case general
	case sports
	case entertainment
	case technology
	case health
	case business
}

protocol NewsListDelegate: AnyObject {
	func tapCategory(value: NewsCategory, completionHandler: @escaping (([Article]) -> Void))
}

class NewsListVC: UIViewController {
	//MARK: - Properties
	@IBOutlet weak var newsTableView: UITableView! {
		didSet {
			newsTableView.separatorStyle = .singleLine
		}
	}
	@IBOutlet weak var cateScrollView: UIScrollView!

	weak var delegate: NewsListDelegate?
	var testNum = 1
	var newsList: [Article]?
	var newsCategory: NewsCategory = .general
	var apiCallMade = false


	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		self.newsTableView.delegate = self
		self.newsTableView.dataSource = self

		// 새로 뉴스를 호출하게되면 리스트가 마지막에 닿은거 apiCallMade 변수 false로 초기화
		NotificationCenter.default.addObserver(self, selector: #selector(noticeReloadNewsApi), name: NSNotification.Name("reCallNewsApi"), object: nil)
		/*
		 ✅ viewcontroller는 UIStoryboard.instantiateViewController(identifier:)
		 ✅ view는 UINib(nibName:)
		 */
		let nib = UINib(nibName: "NewsTVC", bundle: nil)
		self.newsTableView.register(nib, forCellReuseIdentifier: "NewsTVC")
		self.newsTableView.infiniteScrollDirection = .vertical
		self.newsTableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
		self.newsTableView.infiniteScrollIndicatorMargin = 40
		self.newsTableView.infiniteScrollTriggerOffset = 500
		self.newsTableView.addInfiniteScroll { [weak self] tableView in
			DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
				tableView.finishInfiniteScroll()
			})
		}

		self.configureCornerRadius()
	}

	//MARK: - func ============================================
	@objc func noticeReloadNewsApi() {
		self.apiCallMade = false
	}
	/// view의 왼쪽 상단, 오른쪽 상단 cornerRadius 설정
	private func configureCornerRadius() {
		let maskPath = UIBezierPath(roundedRect: self.view.bounds,
		                            byRoundingCorners: [.topLeft, .topRight],
		                            cornerRadii: CGSize(width: 20.0, height: 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.path = maskPath.cgPath
		self.view.layer.mask = maskLayer
	}
	/// date formatter
	private func formatDate(dateString: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = formatter.date(from: dateString)

		formatter.dateFormat = "yyyy년 MM월 dd일"
		return formatter.string(from: date!)
	}

	/// 뉴스 카테고리 탭

	@IBAction func tapNewsCategory(_ sender: UIButton) {
		switch sender.titleLabel?.text {
		case "일반":
			self.newsCategory = .general
		case "스포츠":
			self.newsCategory = .sports
		case "연예":
			self.newsCategory = .entertainment
		case "기술":
			self.newsCategory = .technology
		case "건강":
			self.newsCategory = .health
		case "비즈니스":
			self.newsCategory = .business
		default:
			break
		}

		self.delegate?.tapCategory(value: self.newsCategory, completionHandler: { list in
			self.newsList = list
			self.newsTableView.reloadData()
		})
	}
}


//MARK: - UITableViewDelegate
extension NewsListVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true) // Deselect the row when tapped

		// Get the selected news article's URL
		guard let list = self.newsList else { return }
		let url = list[indexPath.row].url
		// Create the WebViewController
		let webViewController = NewsWebVC(url: url)

		// Present or push the WebViewController
		//self.navigationController?.pushViewController(webViewController, animated: true)
		self.present(webViewController, animated: true)
	}
}

//MARK: - UITableViewDataSource
extension NewsListVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let news = self.newsList else { return 0 }
		return news.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTVC", for: indexPath) as? NewsTVC else { return UITableViewCell() }
		if let news = self.newsList {
			if let lastHyphen = news[indexPath.row].title.lastIndex(of: "-") {
				let resultString = String(news[indexPath.row].title.prefix(upTo: lastHyphen)).trimmingCharacters(in: .whitespaces)
				cell.titleLabel?.text = resultString
			} else {
				cell.titleLabel?.text = news[indexPath.row].title
			}
			cell.authorLabel?.text = news[indexPath.row].author
			cell.dateLabel?.text = self.formatDate(dateString: news[indexPath.row].publishedAt)
			cell.linkUrl = news[indexPath.row].url
		}
		return cell
	}
}

