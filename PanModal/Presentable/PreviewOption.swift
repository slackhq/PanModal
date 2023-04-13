//
//  PreviewOption.swift
//  PanModal
//
//  Created by VLADIMIR LEVTSOV on 05.04.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import Foundation

public enum PreviewOption {
	case fixedPreviewSize(CGSize)
	case aspectRatio(CGFloat)
	case minHorizontalInset(CGFloat)
	///the minimum percentage of filling the entire width of the container
	case fillMinWidthRatio(CGFloat)
	///the minimum percentage of filling the entire height of the container
	case fillMinHeightRatio(CGFloat)
	///fill the container by min sides with a given multiple relative to the corresponding side
	case fillByMinSide(mult: CGFloat, W_HAspoct: CGFloat)
}
