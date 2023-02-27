//
//  UIView+Ext.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/20.
//

import Foundation
import UIKit

@IBDesignable extension UIView {

	// 그림자 색
	@IBInspectable var shadowColor: UIColor? {
		set {
			layer.shadowColor = newValue?.cgColor
		}
		get {
			if let color = layer.shadowColor {
				return UIColor(cgColor: color)
			} else {
				return nil
			}
		}
	}

	// 그림자 사이즈
	@IBInspectable var shadowOffset: CGSize {
		set {
			layer.shadowOffset = newValue
		}
		get {
			return layer.shadowOffset
		}
	}

	// 그림자 투명도
	@IBInspectable var shadowOpacity: Float {
		set {
			if (0...1).contains(newValue) {
				layer.shadowOpacity = newValue
			} else {
				layer.shadowOpacity = 0
			}
		}
		get {
			return layer.shadowOpacity
		}
	}

	// 그림자 둥근테두리?
	@IBInspectable var shadowRadius: CGFloat {
		set {
			layer.shadowRadius = newValue
		}
		get {
			return layer.shadowRadius
		}
	}

	// 테두리 선 두께
	@IBInspectable var borderWidth: CGFloat {
		set {
			layer.borderWidth = newValue
		}
		get {
			return layer.borderWidth
		}
	}

	// 테두리 둥글게
	@IBInspectable var cornerRadius: CGFloat {
		set {
			layer.cornerRadius = newValue
		}
		get {
			return layer.cornerRadius
		}
	}

	// 테두리 선
	@IBInspectable var borderColor: UIColor? {
		set {
			guard let uicolor = newValue else { return }
			layer.borderColor = uicolor.cgColor
		}
		get {
			guard let color = layer.borderColor else { return nil }
			return UIColor(cgColor: color)
		}
	}
}



