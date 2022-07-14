//
//  PanModalNavigationController.swift
//  PanModal
//
//  Created by Semen Kologrivov on 07.07.2022.
//
import UIKit

open class PanModalNavController: UINavigationController, PanModalPresentable {

    public var currentHeight: CGFloat = .zero
    public var currentStateKeyboardIsShown = false

    public var presentViewController: (UIViewController & PanModalPresentable) {
        guard let viewControllers = self.viewControllers.last as? (UIViewController & PanModalPresentable) else {
            fatalError("impl top controller PanModalPresentable")
        }

        return viewControllers
    }

    open func updatePanModal(toState state: PanModalPresentationController.PresentationState = .longForm) {
        let inset = self.panScrollable?.contentInset ?? .zero

        self.panModalSetNeedsLayoutUpdate()
        self.panModalTransition(to: state)

        self.panScrollable?.contentInset = inset
    }

// MARK: - PanModalPresentable
    open var panScrollable: UIScrollView? {
        self.presentViewController.panScrollable
    }

    open var topOffset: CGFloat {
        self.presentViewController.topOffset
    }

    open var longFormHeight: PanModalHeight {
        guard let panScrollable = self.presentViewController as? PanModalKeyboardPresentable else {
            return .contentHeight(.zero)
        }

        let height = panScrollable.contentWithKeyboardHeight

        if abs(height - self.currentHeight) < 5 {
            return .contentHeight(self.currentHeight)
        }

        self.currentHeight = height

        return .contentHeight(height)
    }

    open var cornerRadius: CGFloat {
        self.presentViewController.cornerRadius
    }

    open var springDamping: CGFloat {
        1
    }

    open var transitionDuration: Double {
        self.presentViewController.transitionDuration
    }

    open var transitionAnimationOptions: UIView.AnimationOptions {
        self.presentViewController.transitionAnimationOptions
    }

    open var panModalBackgroundColor: UIColor {
        self.presentViewController.panModalBackgroundColor
    }

    open var dragIndicatorBackgroundColor: UIColor {
        self.presentViewController.dragIndicatorBackgroundColor
    }

    open var scrollIndicatorInsets: UIEdgeInsets {
        self.presentViewController.scrollIndicatorInsets
    }

    open var anchorModalToLongForm: Bool {
        self.presentViewController.anchorModalToLongForm
    }

    open var allowsExtendedPanScrolling: Bool {
        self.presentViewController.allowsExtendedPanScrolling
    }

    open var allowsDragToDismiss: Bool {
        self.presentViewController.allowsDragToDismiss
    }

    open var allowsTapToDismiss: Bool {
        self.presentViewController.allowsTapToDismiss
    }

    open var isUserInteractionEnabled: Bool {
        self.presentViewController.isUserInteractionEnabled
    }

    open var isHapticFeedbackEnabled: Bool {
        self.presentViewController.isHapticFeedbackEnabled
    }

    open var shouldRoundTopCorners: Bool {
        self.presentViewController.shouldRoundTopCorners
    }

    open var showDragIndicator: Bool {
        self.presentViewController.showDragIndicator
    }

    open func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        self.presentViewController.shouldRespond(to: panModalGestureRecognizer)
    }

    open func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) {
        self.presentViewController.willRespond(to: panModalGestureRecognizer)
    }

    open func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        self.presentViewController.shouldPrioritize(panModalGestureRecognizer: panModalGestureRecognizer)
    }

    open func shouldTransition(to state: PanModalPresentationController.PresentationState) -> Bool {
        self.presentViewController.shouldTransition(to: state)
    }

    open func willTransition(to state: PanModalPresentationController.PresentationState) {
        self.presentViewController.willTransition(to: state)
    }

    open func panModalWillDismiss() {
        self.presentViewController.panModalWillDismiss()
    }

    open func panModalDidDismiss() {
        self.presentViewController.panModalDidDismiss()
    }
}
