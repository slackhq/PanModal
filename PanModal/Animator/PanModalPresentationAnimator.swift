//
//  PanModalPresentationAnimator.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
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

        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
            else { return }

		let containerView = transitionContext.containerView
        let presentable = panModalLayoutType(from: transitionContext)

        // Calls viewWillAppear and viewWillDisappear
        fromVC.beginAppearanceTransition(false, animated: true)
        
        // Presents the view in shortForm position, initially
        let yPos: CGFloat = presentable?.shortFormYPos ?? 0.0

        // Use panView as presentingView if it already exists within the containerView
        let panView: UIView = containerView.panContainerView ?? toVC.view

        // Move presented view offscreen (from the bottom)
        panView.frame = transitionContext.finalFrame(for: toVC)
        panView.frame.origin.y = containerView.frame.height

        // Haptic feedback
        if presentable?.isHapticFeedbackEnabled == true {
            feedbackGenerator?.selectionChanged()
        }

		// Preview
		let toPreviewView: UIView? = containerView.previewContainerView?.subviews.first
		let fromPreviewView: UIView? = presentable?.preview?.sourceView
		let snapshot: UIView? = presentable?.preview?.sourceCopy
		snapshot?.clipsToBounds = true

		if let fromPreviewView,
		   let toPreviewView,
		   let snapshot,
		   let presentable
		{
			snapshot.contentMode = fromPreviewView.contentMode
			toPreviewView.isHidden = true
			containerView.addSubview(snapshot)
			if presentable.previewTransitionOptions.contains(.fadeIn) {
				snapshot.alpha = 0
			}
			snapshot.frame = containerView.convert(fromPreviewView.frame, from: fromPreviewView.superview)
		}

        PanModalAnimator.animate(
			{
				panView.frame.origin.y = yPos
				if let presentable {
					if case .loadable = presentable.preview {
						snapshot?.alpha = 0
					} else if presentable.previewTransitionOptions.contains(.fadeIn) {
						snapshot?.alpha = 1
					}
					if let toPreviewView {
						if presentable.previewTransitionOptions.contains(.viewToViewIn) && snapshot?.frame != .zero {
							snapshot?.frame = containerView.convert(toPreviewView.frame, from: toPreviewView.superview)
						}
						snapshot?.contentMode = toPreviewView.contentMode
						snapshot?.layoutIfNeeded()
					}
				}

			},
			config: presentable
		) { [weak self, weak presentable] didComplete in
			// Calls viewDidAppear and viewDidDisappear
			snapshot?.removeFromSuperview()
			toPreviewView?.isHidden = false
			presentable?.panModalDidDisplayPreview(view: toPreviewView)
			fromVC.endAppearanceTransition()
			transitionContext.completeTransition(didComplete)
			self?.feedbackGenerator = nil
		}
    }

    /**
     Animate presented view controller dismissal
     */
    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {

        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
            else { return }
		let containerView = transitionContext.containerView
        // Calls viewWillAppear and viewWillDisappear
        toVC.beginAppearanceTransition(true, animated: true)
        
        let presentable = panModalLayoutType(from: transitionContext)
        let panView: UIView = containerView.panContainerView ?? fromVC.view

		// Preview
		let toPreviewView: UIView? = presentable?.preview?.sourceView
		let fromPreviewView: UIView? = containerView.previewContainerView?.subviews.first
		let snapshot: UIView? = fromPreviewView?.snapshotView(afterScreenUpdates: false)
		snapshot?.clipsToBounds = true

		if let fromPreviewView,
		   let snapshot {
			snapshot.contentMode = fromPreviewView.contentMode
			fromPreviewView.isHidden = true
			containerView.addSubview(snapshot)
			snapshot.frame = containerView.convert(fromPreviewView.frame, from: fromPreviewView.superview)
		}

		PanModalAnimator.animate(
			{
				panView.frame.origin.y = transitionContext.containerView.frame.height
				if let toPreviewView,
				   let presentable {
					let toFrame = containerView.convert(toPreviewView.frame, from: toPreviewView.superview)
					if toFrame == .zero {
						snapshot?.alpha = 0
					} else if presentable.previewTransitionOptions.contains(.viewToViewOut) {
						snapshot?.frame = toFrame
					}
					snapshot?.contentMode = toPreviewView.contentMode
					snapshot?.layoutIfNeeded()
				}
			},
			keyFrameAnimations: [
				{ [weak presentable, weak snapshot] in
					if presentable?.previewTransitionOptions.contains(.fadeOut) ?? false {
						UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
							snapshot?.alpha = 0
						}
					}
				}
			],
			config: presentable
		) { didComplete in
			fromVC.view.removeFromSuperview()
			snapshot?.removeFromSuperview()
			// Calls viewDidAppear and viewDidDisappear
			toVC.endAppearanceTransition()
			transitionContext.completeTransition(didComplete)
		}
    }

    /**
     Extracts the PanModal from the transition context, if it exists
     */
    private func panModalLayoutType(from context: UIViewControllerContextTransitioning) -> PanModalPresentable.LayoutType? {
        switch transitionStyle {
        case .presentation:
            return context.viewController(forKey: .to) as? PanModalPresentable.LayoutType
        case .dismissal:
            return context.viewController(forKey: .from) as? PanModalPresentable.LayoutType
        }
    }

}

// MARK: - UIViewControllerAnimatedTransitioning Delegate

extension PanModalPresentationAnimator: UIViewControllerAnimatedTransitioning {

    /**
     Returns the transition duration
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        guard
            let context = transitionContext,
            let presentable = panModalLayoutType(from: context)
            else { return PanModalAnimator.Constants.defaultTransitionDuration }

        return presentable.transitionDuration
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
#endif
