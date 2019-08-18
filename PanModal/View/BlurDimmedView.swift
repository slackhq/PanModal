//
//  BlurDimmedView.swift
//  PanModal
//
//  Created by Nikita Nikitsky on 16/08/2019.
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 A dim view with blur effect for use as an overlay over content you want dimmed.
 */
class BlurDimmedView: UIVisualEffectView, DimmedView {

    // MARK: - Properties

    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max:
                animator.fractionComplete = blurDegree
            case .off:
                animator.fractionComplete = 0.0
            case .percent(let percentage):
                let val = max(0.0, min(1.0, percentage))
                animator.fractionComplete = val * blurDegree
            }
        }
    }

    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)?

    /**
     Tap gesture recognizer
     */
    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(didTapView))
    }()

    private let blurDegree: CGFloat
    private var animator: UIViewPropertyAnimator!

    // MARK: - Initializers

    init(style: UIBlurEffect.Style, degree: CGFloat) {
        self.blurDegree = degree
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear) {
            self.effect = UIBlurEffect(style: style)
        }
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Deinitializer

    deinit {
        animator.stopAnimation(true)
    }

    // MARK: - Event Handlers

    @objc private func didTapView() {
        animator.fractionComplete = 0.0
        didTap?(tapGesture)
    }

}
