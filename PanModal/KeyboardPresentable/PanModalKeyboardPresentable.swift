//
//  PanModalKeyboardPresentable.swift
//  PanModal
//
//  Created by Semen Kologrivov on 07.07.2022.
//

import UIKit

public protocol PanModalKeyboardPresentable: PanModalPresentable {

    var keyboardIsShown: Bool { get }

    var minimumHeight: CGFloat { get }
    var keyboardHeight: CGFloat { get }
    var extrasHeight: CGFloat { get }
    var contentWithKeyboardHeight: CGFloat { get }
    
    var keyboardScrollView: UIScrollView? { get }
}
