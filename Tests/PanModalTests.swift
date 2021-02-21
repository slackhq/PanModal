//
//  PanModalTests.swift
//  PanModalTests
//
//  Created by Tosin Afolabi on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import XCTest
@testable import PanModal

/**
 ⚠️ Run tests on iPhone 8 iOS (12.1) Sim
 */

class PanModalTests: XCTestCase {

    class MockViewController: UIViewController, PanModalPresentable {
        var panScrollable: UIScrollView? { return nil }
    }

    class AdjustedMockViewController: UITableViewController, PanModalPresentable {
        var panScrollable: UIScrollView? { return tableView }
        var shortFormHeight: PanModalHeight { return .contentHeight(300) }
        var longFormHeight: PanModalHeight { return .maxHeightWithTopInset(50) }
        // for testing purposes - to mimic safe area insets
        var topLayoutOffset: CGFloat { return 20 }
        var bottomLayoutOffset: CGFloat { return 44 }
    }

    private var vc: AdjustedMockViewController!

    override func setUp() {
        super.setUp()
        vc = AdjustedMockViewController()
    }

    override func tearDown() {
        super.tearDown()
        vc = nil
    }

    func testPresentableDefaults() {

        let vc = MockViewController()

        XCTAssertEqual(vc.topOffset, 41.0)
        XCTAssertEqual(vc.shortFormHeight, PanModalHeight.maxHeight)
        XCTAssertEqual(vc.longFormHeight, PanModalHeight.maxHeight)
        XCTAssertEqual(vc.panModalBackgroundColor, UIColor.black.withAlphaComponent(0.7))
        XCTAssertEqual(vc.dragIndicatorBackgroundColor, UIColor.lightGray)
        XCTAssertEqual(vc.scrollIndicatorInsets, .zero)
        XCTAssertEqual(vc.anchorModalToLongForm, true)
        XCTAssertEqual(vc.allowsExtendedPanScrolling, false)
        XCTAssertEqual(vc.allowsDragToDismiss, true)
        XCTAssertEqual(vc.allowsTapToDismiss, true)
        XCTAssertEqual(vc.isUserInteractionEnabled, true)
        XCTAssertEqual(vc.isHapticFeedbackEnabled, true)
        XCTAssertEqual(vc.shouldRoundTopCorners, false)
        XCTAssertEqual(vc.showDragIndicator, false)
        XCTAssertEqual(vc.shouldRoundTopCorners, false)
        XCTAssertEqual(vc.cornerRadius, 8.0)
    }

    func testPresentableYValues() {

        XCTAssertEqual(vc.topLayoutOffset, 20)
        XCTAssertEqual(vc.bottomLayoutOffset, 44)

        XCTAssertEqual(vc.topMargin(from: .maxHeight), 0)
        XCTAssertEqual(vc.topMargin(from: .maxHeightWithTopInset(40)), 40)
        XCTAssertEqual(vc.topMargin(from: .contentHeight(200)), 447)
        XCTAssertEqual(vc.topMargin(from: .contentHeightIgnoringSafeArea(200)), 447)

        XCTAssertEqual(vc.shortFormYPos, 388)
        XCTAssertEqual(vc.longFormYPos, 91)
        XCTAssertEqual(vc.bottomYPos, vc.view.frame.height)

        XCTAssertEqual(vc.view.frame.height, UIScreen.main.bounds.size.height - 20)
    }
}
