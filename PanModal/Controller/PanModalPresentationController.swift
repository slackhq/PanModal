//
//  PanModalPresentationController.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 The PanModalPresentationController is the middle layer between the presentingViewController
 and the presentedViewController.

 It controls the coordination between the individual transition classes as well as
 provides an abstraction over how the presented view is presented & displayed.

 For example, we add a drag indicator view above the presented view and
 a background overlay between the presenting & presented view.

 The presented view's layout configuration & presentation is defined using the PanModalPresentable.

 By conforming to the PanModalPresentable protocol & overriding values
 the presented view can define its layout configuration & presentation.
 */
open class PanModalPresentationController: UIPresentationController {

    /**
     Enum representing the possible presentation states
     */
    public enum PresentationState {
        case shortForm
        case longForm
    }

    /**
     Constants
     */
    struct Constants {
        static let indicatorYOffset = CGFloat(8.0)
        static let snapMovementSensitivity = CGFloat(0.7)
        static let dragIndicatorSize = CGSize(width: 36.0, height: 5.0)
    }

    // MARK: - Properties

    /**
     A flag to track if the presented view is animating
     */
    private var isPresentedViewAnimating = false

    /**
     A flag to determine if scrolling should seamlessly transition
     from the pan modal container view to the scroll view
     once the scroll limit has been reached.
     */
    private var extendsPanScrolling = true

    /**
     A flag to determine if scrolling should be limited to the longFormHeight.
     Return false to cap scrolling at .max height.
     */
    private var anchorModalToLongForm = true

    /**
     The y content offset value of the embedded scroll view
     */
    private var scrollViewYOffset: CGFloat = 0.0

    /**
     An observer for the scroll view content offset
     */
    private var scrollObserver: NSKeyValueObservation?

    // store the y positions so we don't have to keep re-calculating

    /**
     The y value for the short form presentation state
     */
    private var shortFormYPosition: CGFloat = 0

    /**
     The y value for the long form presentation state
     */
    private var longFormYPosition: CGFloat = 0

    /**
     Determine anchored Y postion based on the `anchorModalToLongForm` flag
     */
    private var anchoredYPosition: CGFloat {
        let defaultTopOffset = presentable?.topOffset ?? 0
        return anchorModalToLongForm ? longFormYPosition : defaultTopOffset
    }

    /**
     Configuration object for PanModalPresentationController
     */
    private var presentable: PanModalPresentable? {
        return presentedViewController as? PanModalPresentable
    }

    // MARK: - Views

    /**
     Background view used as an overlay over the presenting view
     */
    private lazy var backgroundView: DimmedView = {
        let view: DimmedView
        if let color = presentable?.panModalBackgroundColor {
            view = DimmedView(dimColor: color)
        } else {
            view = DimmedView()
        }
        view.didTap = { [weak self] _ in
            if self?.presentable?.allowsTapToDismiss == true {
                self?.presentedViewController.dismiss(animated: true)
            }
        }
        return view
    }()

    /**
     A wrapper around the presented view so that we can modify
     the presented view apperance without changing
     the presented view's properties
     */
    private lazy var panContainerView: PanContainerView = {
        let frame = containerView?.frame ?? .zero
        return PanContainerView(presentedView: presentedViewController.view, frame: frame)
    }()

    /**
     Drag Indicator View
     */
    private lazy var dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = presentable?.dragIndicatorBackgroundColor
        view.layer.cornerRadius = Constants.dragIndicatorSize.height / 2.0
        return view
    }()

    /**
     Override presented view to return the pan container wrapper
     */
    public override var presentedView: UIView {
        return panContainerView
    }

    // MARK: - Gesture Recognizers

    /**
     Gesture recognizer to detect & track pan gestures
     */
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnPresentedView(_ :)))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = self
        return gesture
    }()

    // MARK: - Deinitializers

    deinit {
        scrollObserver?.invalidate()
    }

    // MARK: - Lifecycle

    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        configureViewLayout()
    }

    override public func presentationTransitionWillBegin() {

        guard let containerView = containerView
            else { return }

        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        configureScrollViewInsets()

        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .max
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .max
            self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if completed { return }

        backgroundView.removeFromSuperview()
    }

    override public func dismissalTransitionWillBegin() {
        presentable?.panModalWillDismiss()

        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .off
            return
        }

        /**
         Drag indicator is drawn outside of view bounds
         so hiding it on view dismiss means avoiding visual bugs
         */
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dragIndicatorView.alpha = 0.0
            self?.backgroundView.dimState = .off
            self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed { return }
        
        presentable?.panModalDidDismiss()
    }

    /**
     Update presented view size in response to size class changes
     */
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard
                let self = self,
                let presentable = self.presentable
                else { return }

            self.adjustPresentedViewFrame()
            if presentable.shouldRoundTopCorners {
                self.addRoundedCorners(to: self.presentedView)
            }
        })
    }

}

// MARK: - Public Methods

public extension PanModalPresentationController {

    /**
     Transition the PanModalPresentationController
     to the given presentation state
     */
    func transition(to state: PresentationState) {

        guard presentable?.shouldTransition(to: state) == true
            else { return }

        presentable?.willTransition(to: state)

        switch state {
        case .shortForm:
            snap(toYPosition: shortFormYPosition)
        case .longForm:
            snap(toYPosition: longFormYPosition)
        }
    }

    /**
     Operations on the scroll view, such as content height changes,
     or when inserting/deleting rows can cause the pan modal to jump,
     caused by the pan modal responding to content offset changes.

     To avoid this, you can call this method to perform scroll view updates,
     with scroll observation temporarily disabled.
     */
    func performUpdates(_ updates: () -> Void) {

        guard let scrollView = presentable?.panScrollable
            else { return }

        // Pause scroll observer
        scrollObserver?.invalidate()
        scrollObserver = nil

        // Perform updates
        updates()

        // Resume scroll observer
        trackScrolling(scrollView)
        observe(scrollView: scrollView)
    }

    /**
     Updates the PanModalPresentationController layout
     based on values in the PanModalPresentable

     - Note: This should be called whenever any
     pan modal presentable value changes after the initial presentation
     */
    func setNeedsLayoutUpdate() {
        configureViewLayout()
        adjustPresentedViewFrame()
        observe(scrollView: presentable?.panScrollable)
        configureScrollViewInsets()
    }

}

// MARK: - Presented View Layout Configuration

private extension PanModalPresentationController {

    /**
     Boolean flag to determine if the presented view is anchored
     */
    var isPresentedViewAnchored: Bool {
        if !isPresentedViewAnimating
            && extendsPanScrolling
            && presentedView.frame.minY.rounded() <= anchoredYPosition.rounded() {
            return true
        }

        return false
    }

    /**
     Adds the presented view to the given container view
     & configures the view elements such as drag indicator, rounded corners
     based on the pan modal presentable.
     */
    func layoutPresentedView(in containerView: UIView) {

        /**
         If the presented view controller does not conform to pan modal presentable
         don't configure
         */
        guard let presentable = presentable
            else { return }

        /**
         ⚠️ If this class is NOT used in conjunction with the PanModalPresentationAnimator
         & PanModalPresentable, the presented view should be added to the container view
         in the presentation animator instead of here
         */
        containerView.addSubview(presentedView)
        containerView.addGestureRecognizer(panGestureRecognizer)

        if presentable.showDragIndicator {
            addDragIndicatorView(to: presentedView)
        }

        if presentable.shouldRoundTopCorners {
            addRoundedCorners(to: presentedView)
        }

        setNeedsLayoutUpdate()
        adjustPanContainerBackgroundColor()
    }

    /**
     Reduce height of presentedView so that it sits at the bottom of the screen
     */
    func adjustPresentedViewFrame() {

        guard let frame = containerView?.frame
            else { return }

        let adjustedSize = CGSize(width: frame.size.width, height: frame.size.height - anchoredYPosition)
        let panFrame = panContainerView.frame
        panContainerView.frame.size = frame.size
        
        if ![shortFormYPosition, longFormYPosition].contains(panFrame.origin.y) {
            // if the container is already in the correct position, no need to adjust positioning
            // (rotations & size changes cause positioning to be out of sync)
            let yPosition = panFrame.origin.y - panFrame.height + frame.height
            presentedView.frame.origin.y = max(yPosition, anchoredYPosition)
        }
        panContainerView.frame.origin.x = frame.origin.x
        presentedViewController.view.frame = CGRect(origin: .zero, size: adjustedSize)
    }

    /**
     Adds a background color to the pan container view
     in order to avoid a gap at the bottom
     during initial view presentation in longForm (when view bounces)
     */
    func adjustPanContainerBackgroundColor() {
        panContainerView.backgroundColor = presentedViewController.view.backgroundColor
            ?? presentable?.panScrollable?.backgroundColor
    }

    /**
     Adds the background view to the view hierarchy
     & configures its layout constraints.
     */
    func layoutBackgroundView(in containerView: UIView) {
        containerView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    /**
     Adds the drag indicator view to the view hierarchy
     & configures its layout constraints.
     */
    func addDragIndicatorView(to view: UIView) {
        view.addSubview(dragIndicatorView)
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicatorView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -Constants.indicatorYOffset).isActive = true
        dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragIndicatorView.widthAnchor.constraint(equalToConstant: Constants.dragIndicatorSize.width).isActive = true
        dragIndicatorView.heightAnchor.constraint(equalToConstant: Constants.dragIndicatorSize.height).isActive = true
    }

    /**
     Calculates & stores the layout anchor points & options
     */
    func configureViewLayout() {

        guard let layoutPresentable = presentedViewController as? PanModalPresentable.LayoutType
            else { return }

        shortFormYPosition = layoutPresentable.shortFormYPos
        longFormYPosition = layoutPresentable.longFormYPos
        anchorModalToLongForm = layoutPresentable.anchorModalToLongForm
        extendsPanScrolling = layoutPresentable.allowsExtendedPanScrolling

        containerView?.isUserInteractionEnabled = layoutPresentable.isUserInteractionEnabled
    }

    /**
     Configures the scroll view insets
     */
    func configureScrollViewInsets() {

        guard
            let scrollView = presentable?.panScrollable,
            !scrollView.isScrolling
            else { return }

        /**
         Disable vertical scroll indicator until we start to scroll
         to avoid visual bugs
         */
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollIndicatorInsets = presentable?.scrollIndicatorInsets ?? .zero

        /**
         Set the appropriate contentInset as the configuration within this class
         offsets it
         */
        scrollView.contentInset.bottom = presentable?.bottomScrollInset ?? presentingViewController.bottomLayoutGuide.length

        /**
         As we adjust the bounds during `handleScrollViewTopBounce`
         we should assume that contentInsetAdjustmentBehavior will not be correct
         */
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }

}

// MARK: - Pan Gesture Event Handler

private extension PanModalPresentationController {

    /**
     The designated function for handling pan gesture events
     */
    @objc func didPanOnPresentedView(_ recognizer: UIPanGestureRecognizer) {

        guard
            shouldRespond(to: recognizer),
            let containerView = containerView
            else {
                recognizer.setTranslation(.zero, in: recognizer.view)
                return
        }

        switch recognizer.state {
        case .began, .changed:

            /**
             Respond accordingly to pan gesture translation
             */
            respond(to: recognizer)

            /**
             If presentedView is translated above the longForm threshold, treat as transition
             */
            if presentedView.frame.origin.y == anchoredYPosition && extendsPanScrolling {
                presentable?.willTransition(to: .longForm)
            }

        default:

            /**
             Use velocity sensitivity value to restrict snapping
             */
            let velocity = recognizer.velocity(in: presentedView)

            if isVelocityWithinSensitivityRange(velocity.y) {

                /**
                 If velocity is within the sensitivity range,
                 transition to a presentation state or dismiss entirely.

                 This allows the user to dismiss directly from long form
                 instead of going to the short form state first.
                 */
                if velocity.y < 0 {
                    transition(to: .longForm)

                } else if (nearest(to: presentedView.frame.minY, inValues: [longFormYPosition, containerView.bounds.height]) == longFormYPosition
                    && presentedView.frame.minY < shortFormYPosition) || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)

                } else {
                    presentedViewController.dismiss(animated: true)
                }

            } else {

                /**
                 The `containerView.bounds.height` is used to determine
                 how close the presented view is to the bottom of the screen
                 */
                let position = nearest(to: presentedView.frame.minY, inValues: [containerView.bounds.height, shortFormYPosition, longFormYPosition])

                if position == longFormYPosition {
                    transition(to: .longForm)

                } else if position == shortFormYPosition || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)

                } else {
                    presentedViewController.dismiss(animated: true)
                }
            }
        }
    }

    /**
     Determine if the pan modal should respond to the gesture recognizer.

     If the pan modal is already being dragged & the delegate returns false, ignore until
     the recognizer is back to it's original state (.began)

     ⚠️ This is the only time we should be cancelling the pan modal gesture recognizer
     */
    func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard
            presentable?.shouldRespond(to: panGestureRecognizer) == true ||
                !(panGestureRecognizer.state == .began || panGestureRecognizer.state == .cancelled)
            else {
                panGestureRecognizer.isEnabled = false
                panGestureRecognizer.isEnabled = true
                return false
        }
        return !shouldFail(panGestureRecognizer: panGestureRecognizer)
    }

    /**
     Communicate intentions to presentable and adjust subviews in containerView
     */
    func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
        presentable?.willRespond(to: panGestureRecognizer)

        var yDisplacement = panGestureRecognizer.translation(in: presentedView).y

        /**
         If the presentedView is not anchored to long form, reduce the rate of movement
         above the threshold
         */
        if presentedView.frame.origin.y < longFormYPosition {
            yDisplacement /= 2.0
        }
        adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)

        panGestureRecognizer.setTranslation(.zero, in: presentedView)
    }

    /**
     Determines if we should fail the gesture recognizer based on certain conditions

     We fail the presented view's pan gesture recognizer if we are actively scrolling on the scroll view.
     This allows the user to drag whole view controller from outside scrollView touch area.

     Unfortunately, cancelling a gestureRecognizer means that we lose the effect of transition scrolling
     from one view to another in the same pan gesture so don't cancel
     */
    func shouldFail(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {

        /**
         Allow api consumers to override the internal conditions &
         decide if the pan gesture recognizer should be prioritized.

         ⚠️ This is the only time we should be cancelling the panScrollable recognizer,
         for the purpose of ensuring we're no longer tracking the scrollView
         */
        guard !shouldPrioritize(panGestureRecognizer: panGestureRecognizer) else {
            presentable?.panScrollable?.panGestureRecognizer.isEnabled = false
            presentable?.panScrollable?.panGestureRecognizer.isEnabled = true
            return false
        }

        guard
            isPresentedViewAnchored,
            let scrollView = presentable?.panScrollable,
            scrollView.contentOffset.y > 0
            else {
                return false
        }

        let loc = panGestureRecognizer.location(in: presentedView)
        return (scrollView.frame.contains(loc) || scrollView.isScrolling)
    }

    /**
     Determine if the presented view's panGestureRecognizer should be prioritized over
     embedded scrollView's panGestureRecognizer.
     */
    func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return panGestureRecognizer.state == .began &&
            presentable?.shouldPrioritize(panModalGestureRecognizer: panGestureRecognizer) == true
    }

    /**
     Check if the given velocity is within the sensitivity range
     */
    func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
        return (abs(velocity) - (1000 * (1 - Constants.snapMovementSensitivity))) > 0
    }

    func snap(toYPosition yPos: CGFloat) {
        PanModalAnimator.animate({ [weak self] in
            self?.adjust(toYPosition: yPos)
            self?.isPresentedViewAnimating = true
        }, config: presentable) { [weak self] didComplete in
            self?.isPresentedViewAnimating = !didComplete
        }
    }

    /**
     Sets the y position of the presentedView & adjusts the backgroundView.
     */
    func adjust(toYPosition yPos: CGFloat) {
        presentedView.frame.origin.y = max(yPos, anchoredYPosition)
        
        guard presentedView.frame.origin.y > shortFormYPosition else {
            backgroundView.dimState = .max
            return
        }

        let yDisplacementFromShortForm = presentedView.frame.origin.y - shortFormYPosition

        /**
         Once presentedView is translated below shortForm, calculate yPos relative to bottom of screen
         and apply percentage to backgroundView alpha
         */
        backgroundView.dimState = .percent(1.0 - (yDisplacementFromShortForm / presentedView.frame.height))
    }

    /**
     Finds the nearest value to a given number out of a given array of float values

     - Parameters:
        - number: reference float we are trying to find the closest value to
        - values: array of floats we would like to compare against
     */
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
            else { return number }
        return nearestVal
    }
}

// MARK: - UIScrollView Observer

private extension PanModalPresentationController {

    /**
     Creates & stores an observer on the given scroll view's content offset.
     This allows us to track scrolling without overriding the scrollView delegate
     */
    func observe(scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = scrollView?.observe(\.contentOffset, options: .old) { [weak self] scrollView, change in

            /**
             Incase we have a situation where we have two containerViews in the same presentation
             */
            guard self?.containerView != nil
                else { return }

            self?.didPanOnScrollView(scrollView, change: change)
        }
    }

    /**
     Scroll view content offset change event handler

     Also when scrollView is scrolled to the top, we disable the scroll indicator
     otherwise glitchy behaviour occurs

     This is also shown in Apple Maps (reverse engineering)
     which allows us to seamlessly transition scrolling from the panContainerView to the scrollView
     */
    func didPanOnScrollView(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {

        guard
            !presentedViewController.isBeingDismissed,
            !presentedViewController.isBeingPresented
            else { return }

        if !isPresentedViewAnchored && scrollView.contentOffset.y > 0 {

            /**
             Hold the scrollView in place if we're actively scrolling and not handling top bounce
             */
            haltScrolling(scrollView)

        } else if scrollView.isScrolling || isPresentedViewAnimating {

            if isPresentedViewAnchored {
                /**
                 While we're scrolling upwards on the scrollView,
                 store the last content offset position
                 */
                trackScrolling(scrollView)
            } else {
                /**
                 Keep scroll view in place while we're panning on main view
                 */
                haltScrolling(scrollView)
            }

        } else if presentedViewController.view.isKind(of: UIScrollView.self)
            && !isPresentedViewAnimating && scrollView.contentOffset.y <= 0 {

            /**
             In the case where we drag down quickly on the scroll view and let go,
             `handleScrollViewTopBounce` adds a nice elegant touch.
             */
            handleScrollViewTopBounce(scrollView: scrollView, change: change)
        } else {
            trackScrolling(scrollView)
        }
    }

    /**
     Halts the scroll of a given scroll view & anchors it at the `scrollViewYOffset`
     */
    func haltScrolling(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: false)
        scrollView.showsVerticalScrollIndicator = false
    }

    /**
     As the user scrolls, track & save the scroll view y offset.
     This helps halt scrolling when we want to hold the scroll view in place.
     */
    func trackScrolling(_ scrollView: UIScrollView) {
        scrollViewYOffset = max(scrollView.contentOffset.y, 0)
        scrollView.showsVerticalScrollIndicator = presentable?.shouldShowScrollIndicator ?? true
    }

    /**
     To ensure that the scroll transition between the scrollView & the modal
     is completely seamless, we need to handle the case where content offset is negative.

     In this case, we follow the curve of the decelerating scroll view.
     This gives the effect that the modal view and the scroll view are one view entirely.

     - Note: This works best where the view behind view controller is a UIScrollView.
     So, for example, a UITableViewController.
     */
    func handleScrollViewTopBounce(scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {

        guard let oldYValue = change.oldValue?.y, scrollView.isDecelerating
            else { return }

        let yOffset = scrollView.contentOffset.y
        let presentedSize = containerView?.frame.size ?? .zero

        /**
         Decrease the view bounds by the y offset so the scroll view stays in place
         and we can still get updates on its content offset
         */
        presentedView.bounds.size = CGSize(width: presentedSize.width, height: presentedSize.height + yOffset)

        if oldYValue > yOffset {
            /**
             Move the view in the opposite direction to the decreasing bounds
             until half way through the deceleration so that it appears
             as if we're transferring the scrollView drag momentum to the entire view
             */
            presentedView.frame.origin.y = longFormYPosition - yOffset
        } else {
            scrollViewYOffset = 0
            snap(toYPosition: longFormYPosition)
        }

        scrollView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PanModalPresentationController: UIGestureRecognizerDelegate {

    /**
     Do not require any other gesture recognizers to fail
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    /**
     Allow simultaneous gesture recognizers only when the other gesture recognizer's view
     is the pan scrollable view
     */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view == presentable?.panScrollable
    }
}

// MARK: - UIBezierPath

private extension PanModalPresentationController {

    /**
     Draws top rounded corners on a given view
     We have to set a custom path for corner rounding
     because we render the dragIndicator outside of view bounds
     */
    func addRoundedCorners(to view: UIView) {
        let radius = presentable?.cornerRadius ?? 0
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))

        // Draw around the drag indicator view, if displayed
        if presentable?.showDragIndicator == true {
            let indicatorLeftEdgeXPos = view.bounds.width/2.0 - Constants.dragIndicatorSize.width/2.0
            drawAroundDragIndicator(currentPath: path, indicatorLeftEdgeXPos: indicatorLeftEdgeXPos)
        }

        // Set path as a mask to display optional drag indicator view & rounded corners
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask

        // Improve performance by rasterizing the layer
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }

    /**
     Draws a path around the drag indicator view
     */
    func drawAroundDragIndicator(currentPath path: UIBezierPath, indicatorLeftEdgeXPos: CGFloat) {

        let totalIndicatorOffset = Constants.indicatorYOffset + Constants.dragIndicatorSize.height

        // Draw around drag indicator starting from the left
        path.addLine(to: CGPoint(x: indicatorLeftEdgeXPos, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y - totalIndicatorOffset))
        path.addLine(to: CGPoint(x: path.currentPoint.x + Constants.dragIndicatorSize.width, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + totalIndicatorOffset))
    }
}

// MARK: - Helper Extensions

private extension UIScrollView {

    /**
     A flag to determine if a scroll view is scrolling
     */
    var isScrolling: Bool {
        return isDragging && !isDecelerating || isTracking
    }
}
#endif
