//
//  PanModalPresentable+UIViewController.swift
//  PanModal
//
//  Copyright © 2018 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 Extends PanModalPresentable with helper methods
 when the conforming object is a UIViewController
 */
public extension PanModalPresentable where Self: UIViewController {

    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void

    /**
     For Presentation, the object must be a UIViewController & confrom to the PanModalPresentable protocol.
     */
    typealias LayoutType = UIViewController & PanModalPresentable

    /**
     A function wrapper over the `transition(to state: PanModalPresentationController.PresentationState)`
     function in the PanModalPresentationController.
     */
    func panModalTransition(to state: PanModalPresentationController.PresentationState) {
        presentedVC?.transition(to: state)
    }

    /**
     Programmatically set the content offset of the pan scrollable.

     This is required to use while in the short form presentation state,
     as due to content offset observation, setting the content offset directly would fail
     */
    func panModalSetContentOffset(offset: CGPoint) {
        presentedVC?.setContentOffset(offset: offset)
    }

    /**
     A function wrapper over the `setNeedsLayoutUpdate()`
     function in the PanModalPresentationController.

     - Note: This should be called whenever any of the values for the PanModalPresentable protocol are changed.
     */
    func panModalSetNeedsLayoutUpdate() {
        presentedVC?.setNeedsLayoutUpdate()
    }

    /**
     A function wrapper over the animate function in PanModalAnimator.

     This can be used for animation consistency on views within the presented view controller.
     */
    func panModalAnimate(_ animationBlock: @escaping AnimationBlockType, _ completion: AnimationCompletionType? = nil) {
        PanModalAnimator.animate(animationBlock, config: self, completion)
    }

}
