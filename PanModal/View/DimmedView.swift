//
//  DimmedView.swift
//  PanModal
//
//  Updated by Nikita Nikitsky on 16/08/2019.
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 Represents the possible states of the dimmed view.
 max, off or a percentage of effect applied.
 */
public enum DimState {
    case max
    case off
    case percent(CGFloat)
}

/**
 A dim view for use as an overlay over content you want dimmed.
 */
public protocol DimmedView: UIView {

    /**
     The state of the dimmed view
     */
    var dimState: DimState { get set }

    /**
     The closure to be executed when a tap occurs
     */
    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)? { get set }

}
