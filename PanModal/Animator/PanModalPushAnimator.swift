import UIKit

public class PanModalPushAnimator: NSObject {
    /**
     Enum representing the possible transition styles
     */
    public enum TransitionStyle {
        case push
        case pop
    }

    // MARK: - Properties

    /**
     The transition style
     */
    private let transitionStyle: TransitionStyle

    // MARK: - Initializers

    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
    }

    /**
     Animate  view controller push
     */
    private func animatePush(transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from),
              let presentable = toVC as? PanModalPresentable.LayoutType
            else { return }

        let container = transitionContext.containerView
        let wrappedView = PanModalWrappedView(containerView: container,
                                              panModalVC: presentable,
                                              frame: container.frame)
        let panView: UIView = wrappedView.presentedView
        container.addSubview(wrappedView)
        panView.frame = transitionContext.finalFrame(for: toVC)
        panView.frame.origin.y = container.frame.height
        let yPos: CGFloat = presentable.shortFormYPos
        wrappedView.isAnimating = true

        PanModalAnimator.animate({
            panView.frame.origin.y = yPos
            wrappedView.present(to: yPos)
        }, config: presentable) { didComplete in
            transitionContext.completeTransition(didComplete)
            wrappedView.isAnimating = !didComplete

            container.insertSubview(fromVC.view, belowSubview: wrappedView)
        }
    }

    /**
     Animate  view controller pop
     */
    private func animatePop(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let presentable = fromVC as? PanModalPresentable.LayoutType,
              let panView = transitionContext.containerView as? PanContainerView,
              let wrappedView = panView.superview as? PanModalWrappedView
            else { return }

        panView.frame.origin.y = wrappedView.yPosition

        let yPos = toVC.view.frame.height + PanModalPresentationController.Constants.dragIndicatorHeight
        wrappedView.isAnimating = true

        PanModalAnimator.animate({
            panView.frame.origin.y = yPos
            wrappedView.dissmiss()
        }, config: presentable) { didComplete in
            wrappedView.isAnimating = !didComplete

            wrappedView.removeFromSuperview()
            transitionContext.completeTransition(didComplete)
        }
    }

}

// MARK: - UIViewControllerAnimatedTransitioning Delegate

extension PanModalPushAnimator: UIViewControllerAnimatedTransitioning {

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
        case .push:
            animatePush(transitionContext: transitionContext)
        case .pop:
            animatePop(transitionContext: transitionContext)
        }
    }
}
