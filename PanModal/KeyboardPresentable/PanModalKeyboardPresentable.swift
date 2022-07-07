//
//  PanModalKeyboardPresentable.swift
//  PanModal
//
//  Created by Semen Kologrivov on 07.07.2022.
//

import UIKit

public protocol PanModalKeyboardPresentable: PanModalPresentable {

    var keyboardScrollView: UIScrollView { get }
    var titleView: UIView? { get }

    var keyboardHeight: CGFloat { get }
    var keyboardIsShown: Bool { get }

    var minimumHeight: CGFloat { get }

    var extrasHeight: CGFloat { get }

    var contentWithKeyboardHeight: CGFloat { get }

    func updatePanModal()

    func updatePanModal(toState state: PanModalPresentationController.PresentationState)
}
