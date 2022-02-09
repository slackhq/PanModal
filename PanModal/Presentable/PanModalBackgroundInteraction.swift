//
//  PanModelBackgroundInteraction.swift
//  PanModal
//
//  Created by Ilya Kharlamov on 19.08.2020.
//  Copyright © 2020 Detail. All rights reserved.
//
import Foundation

/** Describes the user interaction events that are triggered as the user taps the background */
public enum PanModalBackgroundInteraction: Equatable {

    /** Taps dismiss the modal immediately */
    case dismiss
    
    /** Touches are forwarded to the lower window (In most cases it would be the application main window that will handle it */
    case forwardToParent
    
    /** Touches are forwarded to the first view controller that is not a `PanModalPresentable` */
    case forwardToRoot
    
    /** Taps transition the modal to its short form or forward taps to root if it's in short form */
    case transitionToShortFormOrForwardToRoot

    /** Taps transition the modal to its short form or forward taps to parent if it's in short form */
    case transitionToShortFormOrForwardToParent

     /** Absorbs touches. The modal does nothing (Swallows the touch) */
    case none

}
