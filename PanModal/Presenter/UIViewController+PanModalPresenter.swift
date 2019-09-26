//
//  UIViewController+PanModalPresenterProtocol.swift
//  PanModal
//
//  Copyright © 2019 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 Extends the UIViewController to conform to the PanModalPresenter protocol
 */
extension UIViewController: PanModalPresenter {

    /**
     A flag that returns true if the topmost view controller in the navigation stack
     was presented using the custom PanModal transition

     - Warning: ⚠️ Calling `presentationController` in this function may cause a memory leak. ⚠️

     In most cases, this check will be used early in the view lifecycle and unfortunately,
     there's an Apple bug that causes multiple presentationControllers to be created if
     the presentationController is referenced here and called too early resulting in
     a strong reference to this view controller and in turn, creating a memory leak.
     */
    public var isPanModalPresented: Bool {
        return (transitioningDelegate as? PanModalPresentationDelegate) != nil
    }

    /**
     Configures a view controller for presentation using the PanModal transition

     - Parameters:
        - viewControllerToPresent: The view controller to be presented
        - sourceView: The view containing the anchor rectangle for the popover.
        - sourceRect: The rectangle in the specified view in which to anchor the popover.

     - Note: sourceView & sourceRect are only required for presentation on an iPad.
     */
    public func presentPanModal(_ viewControllerToPresent: PanModalPresentable.LayoutType, sourceView: UIView? = nil, sourceRect: CGRect = .zero) {

        /**
         Here, we deliberately do not check for size classes. More info in `PanModalPresentationDelegate`
         */

        if UIDevice.current.userInterfaceIdiom == .pad {
            viewControllerToPresent.modalPresentationStyle = .popover
            viewControllerToPresent.popoverPresentationController?.sourceRect = sourceRect
            viewControllerToPresent.popoverPresentationController?.sourceView = sourceView ?? view
            viewControllerToPresent.popoverPresentationController?.delegate = PanModalPresentationDelegate.default
        } else {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
            viewControllerToPresent.transitioningDelegate = PanModalPresentationDelegate.default
        }

        present(viewControllerToPresent, animated: true, completion: nil)
    }

}
#endif
