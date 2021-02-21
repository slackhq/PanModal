//
//  PanModalAnimator.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 Helper animation function to keep animations consistent.
 */
struct PanModalAnimator {

    static func makeDefaultAnimator() -> UIViewPropertyAnimator {
        // Note that `duration` is ignored when using timing parameters.
        // The duration is derived from the parameters.
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: UISpringTimingParameters())
        animator.isUserInteractionEnabled = true
        return animator
    }

    static func animate(_ animations: @escaping PanModalPresentable.AnimationBlockType,
                        config: PanModalPresentable?,
                        _ completion: PanModalPresentable.AnimationCompletionType? = nil) {

        let animator = config?.makeAnimator() ?? makeDefaultAnimator()

        animator.addAnimations(animations)

        if let completion = completion {
            animator.addCompletion { position in
                completion(position == .end)
            }
        }

        animator.startAnimation()
    }
}
#endif
