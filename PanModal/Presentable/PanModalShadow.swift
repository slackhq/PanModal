//
//  PanModalShadow.swift
//  PanModalDemo
//
//  Created by Влада Кузнецова on 30.05.23.
//  Copyright © 2023 Detail. All rights reserved.
//

#if os(iOS)
import UIKit

/// An struct that defines shadow parameters
public struct PanModalShadow {

	/// Shadow color. There is no difference between the alpha setting and the opacity setting
	public let color: UIColor

	/// The x coordinate for shadow offset
	public let x: CGFloat

	/// The y coordinate for shadow offset
	public let y: CGFloat

	/// Shadow opacity. There is no difference between the alpha setting and the opacity setting
	public let opacity: Float

	/// Shadow radius. B-parameter in Figma
	public let blur: CGFloat

	/// Shadow stretch (scale) value in points
	public let spread: CGFloat

	public init(
		color: UIColor = .black,
		x: CGFloat = 0,
		y: CGFloat = 0,
		opacity: Float = 1,
		blur: CGFloat = 20,
		spread: CGFloat = 0
	) {
		self.color = color
		self.x = x
		self.y = y
		self.opacity = opacity
		self.blur = blur
		self.spread = spread
	}

	func apply(_ object: CALayer) {
		object.shadowColor = color.cgColor
		object.shadowOffset = CGSize(width: x, height: y)
		object.shadowOpacity = opacity
		object.shadowRadius = blur / 2.0
		object.masksToBounds = false
		if spread == 0 {
			object.shadowPath = nil
		} else {
			let dx = -spread
			let rect = object.bounds.insetBy(dx: dx, dy: dx)
			object.shadowPath = UIBezierPath(rect: rect).cgPath
		}
		object.shouldRasterize = true
		object.rasterizationScale = UIScreen.main.scale
		object.contentsScale = UIScreen.main.scale
	}
}

#endif
