//
//  PlayerView.swift
//  PanModal
//
//  Created by VLADIMIR LEVTSOV on 10.04.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit
import AVFoundation

final class PlayerView: UIView {

	override class var layerClass: AnyClass {
		return AVPlayerLayer.self
	}

	private var player: AVPlayer? {
		get {
			return playerLayer.player
		}
		set {
			playerLayer.player = newValue
		}
	}

	var playerLayer: AVPlayerLayer {
		return layer as! AVPlayerLayer
	}

	private var playerItemContext = 0
	private var playerItem: AVPlayerItem?

	deinit {
		playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
	}

	func play(_ item: AVPlayerItem) {
		setUpPlayerItem(with: item)
	}

	private func setUpPlayerItem(with item: AVPlayerItem) {
		playerItem = item
		playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)

		DispatchQueue.main.async { [weak self] in
			self?.player = AVPlayer(playerItem: self?.playerItem!)
		}
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard context == &playerItemContext else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
			return
		}

		if keyPath == #keyPath(AVPlayerItem.status) {
			let status: AVPlayerItem.Status
			if let statusNumber = change?[.newKey] as? NSNumber {
				status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
			} else {
				status = .unknown
			}
			switch status {
			case .readyToPlay:
				player?.play()
			case .failed:
				print(".failed")
			case .unknown:
				print(".unknown")
			@unknown default:
				print("@unknown default")
			}
		}
	}

}
