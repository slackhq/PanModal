//
//  AnimatorTests.swift
//  PanModalDemo
//
//  Created by Kyle Bashour on 2/21/21.
//  Copyright © 2021 Detail. All rights reserved.
//

import XCTest
@testable import PanModal

class AnimatorTests: XCTestCase {

    class MockViewController: UIViewController, PanModalPresentable {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn, animations: nil)

        var panScrollable: UIScrollView? {
            nil
        }

        func makeAnimator() -> UIViewPropertyAnimator {
            animator
        }
    }

    func testCustomAnimatorIsUsed() {
        let expectation = XCTestExpectation(description: "The custom property animator should be used")
        let controller = MockViewController()

        controller.animator.addCompletion { _ in
            expectation.fulfill()
        }

        PanModalAnimator.animate({}, config: controller)

        wait(for: [expectation], timeout: 1)
    }

    func testCompletionIsCalledWithCustomAnimator() {
        let expectation = XCTestExpectation(description: "The completion block should be called by the animator")
        let controller = MockViewController()

        PanModalAnimator.animate({}, config: controller) { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
