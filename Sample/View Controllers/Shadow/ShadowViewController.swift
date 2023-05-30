//
//  ShadowViewController.swift
//  PanModalDemo
//
//  Created by Влада Кузнецова on 30.05.23.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit

class ShadowViewController: UIViewController {

		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		}
}

extension ShadowViewController: PanModalPresentable {
	var panScrollable: UIScrollView? {
		return nil
	}

	var longFormHeight: PanModalHeight {
		return .maxHeightWithTopInset(10)
	}

	var shortFormHeight: PanModalHeight {
		return .maxHeightWithTopInset(200)
	}

	var panModalBackgroundColor: UIColor { .clear } 

	var showDragIndicator: Bool { false }

	var panModalShadow: PanModalFormParameter<PanModalShadow>? {
		return .init(
			shortFormValue: .init(color: .black, opacity: 0.5, blur: 10),
			longFormValue: .init(color: .black, opacity: 0, blur: 10)
		)
	}

	var panModalBackgroundColorFormed: PanModalFormParameter<UIColor>? {
		return .init(
			shortFormValue: .clear,
			longFormValue: .black.withAlphaComponent(0.35)
		)
	}

	var touchDelegate: UIView? {
		return presentingViewController?.view
	}
}
