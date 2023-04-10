//
//  PreviewItem.swift
//  PanModalDemo
//
//  Created by VLADIMIR LEVTSOV on 07.04.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public enum PreviewItem {
	case gif(sourceView: UIView)
	case image(sourceView: UIView)
	case video(item: AVPlayerItem, sourceView: UIView)
	case loadable(state: (@escaping ((LoadablaItemState) -> Void)) -> (), sourceView: UIView)

	var view: UIView {
		switch self {
		case .gif(let view):
			return view
		case .image(let view):
			return view
		case .video(_, let view):
			return view
		case .loadable(_, let view):
			return view
		}
	}
}

public enum LoadablaItemState {
	case loading
	case loaded(UIView)
	case failed
}
