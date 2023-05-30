//
//  PanModalMixable.swift
//  PanModalDemo
//
//  Created by Влада Кузнецова on 30.05.23.
//  Copyright © 2023 Detail. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol PanModalMixable {
	associatedtype MixedType = Self

	/// mix values, where percent is percent of **other** value
	func mix(with other: MixedType, percent: CGFloat) -> MixedType
}

extension UIColor: PanModalMixable {
	public func mix(with other: UIColor, percent: CGFloat) -> UIColor {
		guard percent > 0 else {
			return self
		}

		guard percent < 1 else {
			return other
		}

		let l1 = 1 - percent
		let l2 = percent

		var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
		other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

		return .init(
			red: l1*r1 + l2*r2,
			green: l1*g1 + l2*g2,
			blue: l1*b1 + l2*b2,
			alpha: l1*a1 + l2*a2
		)
	}
}

extension CGFloat: PanModalMixable {
	public func mix(with other: Self, percent: CGFloat) -> Self {
		guard percent > 0 else { return self }
		guard percent < 1 else { return other }
		return (1 - percent) * self + percent * other
	}
}

extension Float: PanModalMixable {
	public func mix(with other: Self, percent: CGFloat) -> Self {
		guard percent > 0 else { return self }
		guard percent < 1 else { return other }
		return Float(1 - percent) * self + Float(percent) * other
	}
}

extension PanModalShadow: PanModalMixable {
	public func mix(with other: PanModalShadow, percent: CGFloat) -> PanModalShadow {
		guard percent > 0 else {
			return self
		}

		guard percent < 1 else {
			return other
		}

		return .init(
			color: color.mix(with: other.color, percent: percent),
			x: x.mix(with: other.x, percent: percent),
			y: y.mix(with: other.y, percent: percent),
			opacity: opacity.mix(with: other.opacity, percent: percent),
			blur: blur.mix(with: other.blur, percent: percent),
			spread: spread.mix(with: other.spread, percent: percent)
		)
	}
}
#endif
