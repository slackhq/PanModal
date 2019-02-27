//
//  PanModalHeight.swift
//  SlackUI
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 An enum that defines the possible states of the height of a pan modal container view
 for a given presentation state (shortForm, longForm)
 */
public enum PanModalHeight: Equatable {

    /**
     Sets the height to be the maximum height (+ topOffset)
     */
    case maxHeight

    /**
     Sets the height to be the max height with a specified top inset.
     - Note: A value of 0 is equivalent to .maxHeight
     */
    case maxHeightWithTopInset(CGFloat)

    /**
     Sets the height to be the specified content height
     */
    case contentHeight(CGFloat)

    /**
     Sets the height to be the specified content height
     & also ignores the bottomSafeAreaInset
     */
    case contentHeightIgnoringSafeArea(CGFloat)

}
