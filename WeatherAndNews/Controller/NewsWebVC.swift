//
//  NewsWebVC.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/03/15.
//

// WebViewController.swift
import UIKit
import WebKit

class NewsWebVC: UIViewController {
	private let webView = WKWebView()
	private let url: URL
	private let grabberView: UIView = {
		let grabber = UIView()
		grabber.translatesAutoresizingMaskIntoConstraints = false
		grabber.backgroundColor = UIColor(red: 197 / 255, green: 197 / 255, blue: 199 / 255, alpha: 1)
		grabber.layer.cornerRadius = 3
		return grabber
	}()
	private let activityIndicator = UIActivityIndicatorView(style: .large)

	init(url: URL) {
		self.url = url
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = .white
		self.configureGrabber()

		self.webView.navigationDelegate = self
		self.configureWebView()
	}

	private func configureGrabber() {
		self.view.addSubview(self.grabberView)
		NSLayoutConstraint.activate([
			self.grabberView.heightAnchor.constraint(equalToConstant: 5),
			self.grabberView.widthAnchor.constraint(equalToConstant: 35),
			self.grabberView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
			self.grabberView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
		])
	}
	private func configureWebView() {
		self.view.addSubview(self.webView)
		self.webView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.webView.topAnchor.constraint(equalTo: self.grabberView.bottomAnchor, constant: 50),
			self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
		])

		self.activityIndicator.color = .black
		self.activityIndicator.startAnimating()
		view.addSubview(self.activityIndicator)
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])

		let request = URLRequest(url: self.url)
		self.webView.load(request)
	}

	private func showErrorAlert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "확인", style: .default) { _ in
			self.dismiss(animated: true)
		}
		alertController.addAction(okAction)
		self.present(alertController, animated: true)
	}
}

//MARK: - WKNavigationDelegate ==================
extension NewsWebVC: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		self.activityIndicator.stopAnimating()
	}

	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		self.activityIndicator.startAnimating()
	}

	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		self.showErrorAlert(title: "뉴스를 불러오는데 실패하였습니다.", message: "")
	}
}
