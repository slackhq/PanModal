//
//  PanContainerView.swift
//  PanModal
//
//  Copyright © 2018 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 A view wrapper around the presented view in a PanModal transition.

 This allows us to make modifications to the presented view without
 having to do those changes directly on the view
 */
class PanContainerView: UIView {
    
    private weak var presentedViewController: UIViewController?

    init(presentedView: UIView, frame: CGRect) {
        super.init(frame: frame)
        addSubview(presentedView)
        presentedViewController = presentedView.parentViewController
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func accessibilityPerformEscape() -> Bool {
        var shouldPerforEscape: Bool = true
        if let panModalPresentable = presentedViewController as? PanModalPresentable {
            shouldPerforEscape = panModalPresentable.allowsDragToDismiss || panModalPresentable.allowsTapToDismiss
            if shouldPerforEscape {
                presentedViewController?.dismiss(animated: true, completion: nil)
            }
        }
        return shouldPerforEscape
    }
}

private extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

extension UIView {

    /**
     Convenience property for retrieving a PanContainerView instance
     from the view hierachy
     */
    var panContainerView: PanContainerView? {
        return subviews.first(where: { view -> Bool in
            view is PanContainerView
        }) as? PanContainerView
    }

}
#endif
