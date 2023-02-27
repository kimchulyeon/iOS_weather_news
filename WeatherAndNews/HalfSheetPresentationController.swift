//
//  HalfSheetPresentationController.swift
//  WeatherAndNews
//
//  Created by chulyeon kim on 2023/02/27.
//

import UIKit

class HalfSheetPresentationController: UIPresentationController {
	let deviceHalfHeight = UIScreen.main.bounds.height / 2.0
	var panGestureRecognizer: UIPanGestureRecognizer?

	override var frameOfPresentedViewInContainerView: CGRect {
		guard let containerView = containerView else { return .zero }
		return CGRect(x: 0, y: containerView.bounds.height - deviceHalfHeight, width: containerView.bounds.width, height: deviceHalfHeight)
	}

	override func presentationTransitionWillBegin() {
		presentedView?.layer.cornerRadius = 12
		presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

		if let presentedView = presentedView {
			let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
			presentedView.addGestureRecognizer(gestureRecognizer)
			panGestureRecognizer = gestureRecognizer
		}
	}

	@objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
		guard let presentedView = presentedView else { return }

		let translation = gestureRecognizer.translation(in: presentedView.superview)
		let yTranslation = max(0, translation.y)
		let velocity = gestureRecognizer.velocity(in: presentedView.superview)
		let isDraggingDown = velocity.y > 0

		switch gestureRecognizer.state {
		case .changed:
			presentedView.frame.origin.y = containerView!.bounds.height - deviceHalfHeight + yTranslation
		case .ended:
			UIView.animate(withDuration: 0.2) {
				presentedView.frame.origin.y = 40
				presentedView.frame.size.height = self.containerView!.bounds.height
			}
			if isDraggingDown {
				UIView.animate(withDuration: 0.2) {
					presentedView.frame.origin.y = self.deviceHalfHeight
				}
			}
		default:
			break
		}
	}

}
