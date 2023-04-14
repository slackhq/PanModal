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
	case gif(sourceView: UIView, url: URL?, considerParentLayer: Bool)
	case image(sourceView: UIView, url: URL?)
	case animation(sourceView: UIView, url: URL?)
	case video(item: AVPlayerItem, sourceView: UIView)
	case loadable(state: (@escaping ((LoadablaItemState) -> Void)) -> (), sourceView: UIView)

	var view: UIView {
		switch self {
		case .gif(let view, _, _):
			return view
		case .image(let view, _):
			return view
		case .animation(let view, _):
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
