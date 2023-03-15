//
//  NewsTVC.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/03/11.
//

import UIKit

class NewsTVC: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	var linkUrl: URL?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
	}
}
