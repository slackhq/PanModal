//
//  PanModalPresentable.swift
//  PanModal
//
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 This is the configuration object for a view controller
 that will be presented using the PanModal transition.

 Usage:
 ```
 extension YourViewController: PanModalPresentable {
    func shouldRoundTopCorners: Bool { return false }
 }
 ```
 */
public protocol PanModalPresentable: AnyObject {

    /**
     The scroll view embedded in the view controller.
     Setting this value allows for seamless transition scrolling between the embedded scroll view
     and the pan modal container view.
     */
    var panScrollable: UIScrollView? { get }

    /**
     The offset between the top of the screen and the top of the pan modal container view.

     Default value is the topLayoutGuide.length + 21.0.
     */
    var topOffset: CGFloat { get }

    /**
     The height of the pan modal container view
     when in the shortForm presentation state.

     This value is capped to .max, if provided value exceeds the space available.

     Default value is the longFormHeight.
     */
    var shortFormHeight: PanModalHeight { get }

    /**
     The height of the pan modal container view
     when in the longForm presentation state.
     
     This value is capped to .max, if provided value exceeds the space available.

     Default value is .max.
     */
    var longFormHeight: PanModalHeight { get }

    /**
     The corner radius used when `shouldRoundTopCorners` is enabled.

     Default Value is 8.0.
     */
    var cornerRadius: CGFloat { get }

    /**
     The springDamping value used to determine the amount of 'bounce'
     seen when transitioning to short/long form.

     Default Value is 0.8.
     */
    var springDamping: CGFloat { get }

    /**
     The transitionDuration value is used to set the speed of animation during a transition,
     including initial presentation.

     Default value is 0.5.
    */
    var transitionDuration: Double { get }

    /**
     The animation options used when performing animations on the PanModal, utilized mostly
     during a transition.

     Default value is [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState].
    */
    var transitionAnimationOptions: UIView.AnimationOptions { get }

    /**
     The background view color.

     - Note: This is only utilized at the very start of the transition.

     Default Value is black with alpha component 0.7.
    */
    var panModalBackgroundColor: UIColor { get }

    /**
     The drag indicator view color.

     Default value is light gray.
    */
    var dragIndicatorBackgroundColor: UIColor { get }

    /**
     We configure the panScrollable's scrollIndicatorInsets interally so override this value
     to set custom insets.

     - Note: Use `panModalSetNeedsLayoutUpdate()` when updating insets.
     */
    var scrollIndicatorInsets: UIEdgeInsets { get }

    /**
     A flag to determine if scrolling should be limited to the longFormHeight.
     Return false to cap scrolling at .max height.

     Default value is true.
     */
    var anchorModalToLongForm: Bool { get }

    /**
     A flag to determine if scrolling should seamlessly transition from the pan modal container view to
     the embedded scroll view once the scroll limit has been reached.

     Default value is false. Unless a scrollView is provided and the content height exceeds the longForm height.
     */
    var allowsExtendedPanScrolling: Bool { get }

    /**
     A flag to determine if dismissal should be initiated when swiping down on the presented view.

     Return false to fallback to the short form state instead of dismissing.

     Default value is true.
     */
    var allowsDragToDismiss: Bool { get }

    /**
     A flag to determine if dismissal should be initiated when tapping on the dimmed background view.

     - Note: This parameter id deprecated. Use `backgroundInteraction` instead.
     
     Default value is true.
     */
    var allowsTapToDismiss: Bool { get }

    /**
     Describes what happens when the user interacts the background view.

     Default value is .dismiss.
     */
    var backgroundInteraction: PanModalBackgroundInteraction { get }
    
    /**
     A flag to toggle user interactions on the container view.

     - Note: Return false to forward touches to the presentingViewController.

     Default is true.
    */
    var isUserInteractionEnabled: Bool { get }

    /**
     A flag to determine if haptic feedback should be enabled during presentation.

     Default value is true.
     */
    var isHapticFeedbackEnabled: Bool { get }

    /**
     A flag to determine if the top corners should be rounded.

     Default value is true.
     */
    var shouldRoundTopCorners: Bool { get }

    /**
     A flag to determine if a drag indicator should be shown
     above the pan modal container view.

     Default value is true.
     */
    var showDragIndicator: Bool { get }

    /**
     Asks the delegate if the pan modal should respond to the pan modal gesture recognizer.
     
     Return false to disable movement on the pan modal but maintain gestures on the presented view.

     Default value is true.
     */
    func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool

    /**
     Notifies the delegate when the pan modal gesture recognizer state is either
     `began` or `changed`. This method gives the delegate a chance to prepare
     for the gesture recognizer state change.

     For example, when the pan modal view is about to scroll.

     Default value is an empty implementation.
     */
    func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer)

    /**
     Asks the delegate if the pan modal gesture recognizer should be prioritized.

     For example, you can use this to define a region
     where you would like to restrict where the pan gesture can start.

     If false, then we rely solely on the internal conditions of when a pan gesture
     should succeed or fail, such as, if we're actively scrolling on the scrollView.

     Default return value is false.
     */
    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool

    /**
     Asks the delegate if the pan modal should transition to a new state.

     Default value is true.
     */
    func shouldTransition(to state: PanModalPresentationController.PresentationState) -> Bool

    /**
     Notifies the delegate that the pan modal is about to transition to a new state.

     Default value is an empty implementation.
     */
    func willTransition(to state: PanModalPresentationController.PresentationState)

    /**
     Notifies the delegate that the pan modal is about to be dismissed.

     Default value is an empty implementation.
     */
    func panModalWillDismiss()

    /**
     Notifies the delegate after the pan modal is dismissed.

     Default value is an empty implementation.
     */
    func panModalDidDismiss()
}
#endif
