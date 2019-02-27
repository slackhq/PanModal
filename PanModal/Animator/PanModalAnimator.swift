//
//  PanModalAnimator.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 Helper animation function to keep animations consistent.
 */
struct PanModalAnimator {

    /**
     Constant Animation Properties
     */
    struct Constants {
        static let transitionDuration: TimeInterval = 0.5
    }

    static func animate(_ animations: @escaping PanModalPresentable.AnimationBlockType,
                        config: PanModalPresentable?,
                        _ completion: PanModalPresentable.AnimationCompletionType? = nil) {

        UIView.animate(withDuration: Constants.transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: config?.springDamping ?? 1.0,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
                       animations: animations,
                       completion: completion)
    }
}
