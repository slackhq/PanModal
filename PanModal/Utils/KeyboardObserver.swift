//
//  KeyboardObserver.swift
//  PanModal
//
//  Created by VLADIMIR LEVTSOV on 07.11.2022.
//  Copyright © 2022 Detail. All rights reserved.
//

import Foundation
import UIKit

public enum KeyboardEventType: CaseIterable {
	case willShow
	case didShow
	case willHide
	case didHide
	case willChangeFrame
	case didChangeFrame

	public var notificationName: NSNotification.Name {
		switch self {
		case .willShow:
			return UIResponder.keyboardWillShowNotification
		case .didShow:
			return UIResponder.keyboardDidShowNotification
		case .willHide:
			return UIResponder.keyboardWillHideNotification
		case .didHide:
			return UIResponder.keyboardDidHideNotification
		case .willChangeFrame:
			return UIResponder.keyboardWillChangeFrameNotification
		case .didChangeFrame:
			return UIResponder.keyboardDidChangeFrameNotification
		}
	}

	init?(name: NSNotification.Name) {
		switch name {
		case UIResponder.keyboardWillShowNotification:
			self = .willShow
		case UIResponder.keyboardDidShowNotification:
			self = .didShow
		case UIResponder.keyboardWillHideNotification:
			self = .willHide
		case UIResponder.keyboardDidHideNotification:
			self = .didHide
		case UIResponder.keyboardWillChangeFrameNotification:
			self = .willChangeFrame
		case UIResponder.keyboardDidChangeFrameNotification:
			self = .didChangeFrame
		default:
			return nil
		}
	}

	static func allEventNames() -> [NSNotification.Name] {
		allCases.map { $0.notificationName }
	}

	public static var basicEvents: [KeyboardEventType] {
		[.willShow, .willHide, .didChangeFrame]
	}
}

public struct KeyboardEvent {
	public let type: KeyboardEventType
	public let keyboardFrameBegin: CGRect
	public let keyboardFrameEnd: CGRect
	public let curve: UIView.AnimationCurve
	public let duration: TimeInterval
	public var isLocal: Bool?

	public var options: UIView.AnimationOptions {
		UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
	}

	init?(notification: Notification) {
		guard let userInfo = (notification as NSNotification).userInfo,
			  let type = KeyboardEventType(name: notification.name),
			  let begin = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
			  let end = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
			  let curveInt = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
			  let curve = UIView.AnimationCurve(rawValue: curveInt),
			  let durationDouble = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
			  let isLocalInt = (userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.intValue
		else {
			return nil
		}
		self.type = type
		self.keyboardFrameBegin = begin
		self.keyboardFrameEnd = end
		self.curve = curve
		self.duration = TimeInterval(durationDouble)
		self.isLocal = isLocalInt == 1
	}
}

public enum KeyboardState {
	case initial
	case showing
	case shown
	case hiding
	case hidden
	case changing
}

public typealias KeyboardEventClosure = (_ event: KeyboardEvent) -> Void

public protocol KeyboardObserverInterface {
	func observe(_ event: @escaping KeyboardEventClosure)
	func clearObservers()
}

open class KeyboardObserver: KeyboardObserverInterface {
	open var isEnabled = true
	public private(set) var state = KeyboardState.initial
	fileprivate var eventClosures = [KeyboardEventClosure]()

	deinit {
		eventClosures.removeAll()
		KeyboardEventType.allEventNames().forEach {
			NotificationCenter.default.removeObserver(self, name: $0, object: nil)
		}
	}

	public init() {
		KeyboardEventType.allEventNames().forEach {
			NotificationCenter.default.addObserver(
				self,
				selector: #selector(notified(_:)),
				name: $0,
				object: nil
			)
		}
	}

	public init(events: KeyboardEventType...) {
		events.forEach {
			NotificationCenter.default.addObserver(
				self,
				selector: #selector(notified(_:)),
				name: $0.notificationName,
				object: nil
			)
		}
	}

	open func observe(_ event: @escaping KeyboardEventClosure) {
		eventClosures.append(event)
	}

	open func clearObservers() {
		eventClosures.removeAll()
	}
}

internal extension KeyboardObserver {
	@objc
	func notified(_ notification: Notification) {
		guard let event = KeyboardEvent(notification: notification) else {
			return
		}

		switch event.type {
		case .willShow:
			state = .showing
		case .didShow:
			state = .shown
		case .willHide:
			state = .hiding
		case .didHide:
			state = .hidden
		case .willChangeFrame:
			state = .changing
		case .didChangeFrame:
			state = .shown
		}

		if !isEnabled {
			return
		}
		eventClosures.forEach { $0(event) }
	}
}
