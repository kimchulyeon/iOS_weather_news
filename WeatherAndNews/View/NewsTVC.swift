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
	@IBOutlet weak var linkImageButton: UIButton!
	
	var linkUrl: URL?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
	}
	
	/// 링크 버튼 탭
	@IBAction func tapLinkButton(_ sender: UIButton) {
		guard let link = self.linkUrl else { return }
		print(link.description)
	}
}
