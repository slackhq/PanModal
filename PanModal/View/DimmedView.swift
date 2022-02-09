//
//  DimmedView.swift
//  PanModal
//
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/**
 A dim view for use as an overlay over content you want dimmed.
 */
public class DimmedView: UIView {

    /**
     Represents the possible states of the dimmed view.
     max, off or a percentage of dimAlpha.
     */
    enum DimState {
        case max
        case off
        case percent(CGFloat)
    }

    // MARK: - Properties

    /**
     The state of the dimmed view
     */
    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max:
                backgroundColor = dimColor
            case .off:
                backgroundColor = .clear
            case .percent(let percentage):
                backgroundColor = dimColor.withAlphaComponent(max(0.0, min(1.0, percentage)))
            }
        }
    }
    
    /**
     The closure to be executed on hitTest
     */
    var hitTestHandler: ((_ point: CGPoint, _ event: UIEvent?) -> UIView?)?

    /**
     The closure to be executed when a tap occurs
     */
    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)? {
        didSet {
            if self.didTap != nil {
                addGestureRecognizer(tapGesture)
            } else {
                removeGestureRecognizer(tapGesture)
            }
        }
    }

    /**
     Tap gesture recognizer
     */
    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(didTapView))
    }()

    private let dimColor: UIColor
    
    // MARK: - Initializers

    init(dimColor: UIColor = UIColor.black.withAlphaComponent(0.7)) {
        self.dimColor = dimColor
        super.init(frame: .zero)
        backgroundColor = dimColor.withAlphaComponent(0)
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Event Handlers
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.hitTestHandler?(point, event) ?? super.hitTest(point, with: event)
    }

    @objc private func didTapView() {
        didTap?(tapGesture)
    }

}
#endif
