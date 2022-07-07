//
//  PanModalKeyboardPresentable+Defaults.swift
//  PanModal
//
//  Created by Semen Kologrivov on 07.07.2022.
//

import UIKit

public extension PanModalKeyboardPresentable where Self: UIViewController  {

    var extrasHeight: CGFloat {
        .zero
    }

    var minimumHeight: CGFloat {
        .zero
    }

    var contentWithKeyboardHeight: CGFloat {
        let height = self.keyboardScrollView.contentSize.height +
            (self.titleView?.frame.height ?? .zero) +
            self.keyboardHeight +
            self.extrasHeight
        return max(height, self.minimumHeight)
    }

    func updatePanModal() {
        self.updatePanModal(toState: .longForm)
    }

    func updatePanModal(toState state: PanModalPresentationController.PresentationState) {
        (self.navigationController as? PanModalNavController)?.updatePanModal(toState: state)
    }
}
