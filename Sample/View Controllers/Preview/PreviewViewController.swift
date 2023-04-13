//
//  PreviewViewController.swift
//  PanModalDemo
//
//  Created by VLADIMIR LEVTSOV on 28.03.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
    }
    
	var preview: PreviewItem?

	init(preview: PreviewItem? = nil) {
		self.preview = preview
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension PreviewViewController: PanModalPresentable {

	var transitionAnimationOptions: UIView.AnimationOptions {
		return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState, .allowAnimatedContent]
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	var panScrollable: UIScrollView? {
		return nil
	}

	var longFormHeight: PanModalHeight {
		return .maxHeightWithTopInset(200)
	}

	var shortFormHeight: PanModalHeight {
		return .contentHeight(300)
	}

	var anchorModalToLongForm: Bool {
		return false
	}

	var previewOptions: [PreviewOption] {
		switch preview {
		case .loadable:
			return [.fixedPreviewSize(.init(width: 300, height: 300))]
		case .video:
			return [
				.aspectRatio(16.0/9.0),
				.minHorizontalInset(20)
			]
		case let .gif(view, _):
			return [.fixedPreviewSize(view.bounds.size)]
		default:
			return []
		}
	}

}
