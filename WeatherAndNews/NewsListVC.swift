//
//  NewsListVC.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/27.
//

import UIKit

class NewsListVC: UIViewController {
	//MARK: - Properties

	@IBOutlet weak var grabberView: UIView! {
		didSet {
			if #available(iOS 15.0, *) {
				grabberView.isHidden = true
			} else {
				grabberView.isHidden = false
				grabberView.layer.cornerRadius = 2
			}
		}
	}
	@IBOutlet weak var newsTableView: UITableView! {
		didSet {
			newsTableView.separatorStyle = .none
		}
	}
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()


	}

	//MARK: - func ============================================

}


