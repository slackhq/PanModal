//
//  BlurDimmedView.swift
//  PanModal
//
//  Created by Nikita Nikitsky on 16/08/2019.
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 A dim view with color gradient effect for use as an overlay over content you want dimmed.
 */
class GradientDimmedView: UIView, DimmedView {

    // MARK: - Properties

    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max:
                animator.fractionComplete = dimAlpha
            case .off:
                animator.fractionComplete = 0.0
            case .percent(let percentage):
                let val = max(0.0, min(1.0, percentage))
                animator.fractionComplete = val * dimAlpha
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

    private let dimAlpha: CGFloat
    private var animator: UIViewPropertyAnimator!

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Initializers

    init(colors: [UIColor], startPoint: PanModalBackgroundStyle.Point, endPoint: PanModalBackgroundStyle.Point, type: CAGradientLayerType, alpha: CGFloat) {
        dimAlpha = alpha
        super.init(frame: .zero)
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = colors.map({ $0.cgColor })
        gradientLayer?.startPoint = startPoint.cgPoint
        gradientLayer?.endPoint = endPoint.cgPoint
        gradientLayer?.type = type
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear) {
            self.alpha = 1.0
        }
        self.alpha = 0.0
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
