//
//  ImagePreviewViewController.swift
//  PanModalDemo
//
//  Created by VLADIMIR LEVTSOV on 28.03.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
    }
    
	var previewView: UIView?

	init(previewView: UIView? = nil) {
		self.previewView = previewView
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension ImagePreviewViewController: PanModalPresentable {

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
}
