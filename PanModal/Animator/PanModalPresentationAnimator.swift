//
//  PanModalPresentationAnimator.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 Handles the animation of the presentedViewController as it is presented or dismissed.

 This is a vertical animation that
 - Animates up from the bottom of the screen
 - Dismisses from the top to the bottom of the screen

 This can be used as a standalone object for transition animation,
 but is primarily used in the PanModalPresentationDelegate for handling pan modal transitions.

 - Note: The presentedViewController can conform to PanModalPresentable to adjust
 it's starting position through manipulating the shortFormHeight
 */

public class PanModalPresentationAnimator: NSObject {

    /**
     Enum representing the possible transition styles
     */
    public enum TransitionStyle {
        case presentation
        case dismissal
    }

    // MARK: - Properties

    /**
     The transition style
     */
    private let transitionStyle: TransitionStyle

    /**
     Haptic feedback generator (during presentation)
     */
    private var feedbackGenerator: UISelectionFeedbackGenerator?

    // MARK: - Initializers

    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()

        /**
         Prepare haptic feedback, only during the presentation state
         */
        if case .presentation = transitionStyle {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
    }

    /**
     Animate presented view controller presentation
     */
    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to), let fromVC = transitionContext.viewController(forKey: .from)
            else { return }

        let presentable = toVC as? PanModalPresentable.LayoutType

        // Calls viewWillAppear and viewWillDisappear
        fromVC.beginAppearanceTransition(false, animated: true)
        toVC.beginAppearanceTransition(true, animated: true)
        
        // Presents the view in shortForm position, initially
        let yPos: CGFloat = presentable?.shortFormYPos ?? 0.0

        // Use panView as presentingView if it already exists within the containerView
        let panView: UIView = transitionContext.containerView.panContainerView ?? toVC.view

        // Move presented view offscreen (from the bottom)
        panView.frame = transitionContext.finalFrame(for: toVC)
        panView.frame.origin.y = transitionContext.containerView.frame.height

        // Haptic feedback
        if presentable?.isHapticFeedbackEnabled == true {
            feedbackGenerator?.selectionChanged()
        }

        PanModalAnimator.animate({
            panView.frame.origin.y = yPos
        }, config: presentable) { [weak self] didComplete in
            // Calls viewDidAppear and viewDidDisappear
            fromVC.endAppearanceTransition()
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
            self?.feedbackGenerator = nil
        }
    }

    /**
     Animate presented view controller dismissal
     */
    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to)
            else { return }

        // Calls viewWillAppear and viewWillDisappear
        fromVC.beginAppearanceTransition(false, animated: true)
        toVC.beginAppearanceTransition(true, animated: true)
        
        let presentable = fromVC as? PanModalPresentable.LayoutType
        let panView: UIView = transitionContext.containerView.panContainerView ?? fromVC.view

        PanModalAnimator.animate({
            panView.frame.origin.y = transitionContext.containerView.frame.height
        }, config: presentable) { didComplete in
            fromVC.view.removeFromSuperview()
            // Calls viewDidAppear and viewDidDisappear
            fromVC.endAppearanceTransition()
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
        }
    }

}

// MARK: - UIViewControllerAnimatedTransitioning Delegate

extension PanModalPresentationAnimator: UIViewControllerAnimatedTransitioning {

    /**
     Returns the transition duration
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return PanModalAnimator.Constants.transitionDuration
    }

    /**
     Performs the appropriate animation based on the transition style
     */
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionStyle {
        case .presentation:
            animatePresentation(transitionContext: transitionContext)
        case .dismissal:
            animateDismissal(transitionContext: transitionContext)
        }
    }

}
