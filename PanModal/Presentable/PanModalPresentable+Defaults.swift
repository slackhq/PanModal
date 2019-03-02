//
//  PanModalPresentable+Defaults.swift
//  PanModal
//
//  Created by Stephen Sowole on 11/5/18.
//  Copyright © 2018 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 Default values for the PanModalPresentable.
 */
public extension PanModalPresentable where Self: UIViewController {

    var topOffset: CGFloat {
        return topLayoutOffset + 21.0
    }

    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }

    var longFormHeight: PanModalHeight {

        guard let scrollView = panScrollable
            else { return .maxHeight }

        // called once during presentation and stored
        scrollView.layoutIfNeeded()
        return .contentHeight(scrollView.contentSize.height)
    }

    var springDamping: CGFloat {
        return 0.8
    }

    var backgroundAlpha: CGFloat {
        return 0.7
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        let top = shouldRoundTopCorners ? PanModalPresentationController.Constants.cornerRadius : 0
        return UIEdgeInsets(top: CGFloat(top), left: 0, bottom: bottomLayoutOffset, right: 0)
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    var allowsExtendedPanScrolling: Bool {

        guard let scrollView = panScrollable
            else { return false }

        scrollView.layoutIfNeeded()
        return scrollView.contentSize.height > (scrollView.frame.height - bottomLayoutOffset)
    }

    var allowsDragToDismiss: Bool {
        return true
    }

    var isPanScrollEnabled: Bool {
        return true
    }

    var isUserInteractionEnabled: Bool {
        return true
    }

    var isHapticFeedbackEnabled: Bool {
        return true
    }

    var shouldRoundTopCorners: Bool {
        return isPanModalPresented
    }

    var showDragIndicator: Bool {
        return shouldRoundTopCorners
    }

    func willRespond(to panGestureRecognizer: UIPanGestureRecognizer) {

    }

    func shouldTransition(to state: PanModalPresentationController.PresentationState) -> Bool {
        return true
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return false
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {

    }

    func panModalWillDismiss() {

    }

}
