//
//  UIAccessiblityPerformEscapeTests.swift
//  PanModalTests
//
//  Created by Sungdoo on 2022/03/17.
//  Copyright © 2022 Detail. All rights reserved.
//

import XCTest
import PanModal

class UIAccessiblityPerformEscapeTests: XCTestCase {

    class MockViewController: UIViewController, PanModalPresentable {
        var panScrollable: UIScrollView? { return nil }
    }

    func testAccessibilityPerformEscape() throws {
        
        let presenterViewController = UIApplication.shared.keyWindow?.rootViewController
        let panModal: UIViewController & PanModalPresentable = MockViewController()
        
        presenterViewController?.presentPanModal(panModal)
        XCTAssertNotNil(presenterViewController?.presentedViewController, "panModal should have been presented")
        
        let presentDidFisnish = XCTestExpectation()
        let dismissDidFinish = XCTestExpectation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let panContainerView = panModal.view.superview
            presentDidFisnish.fulfill()
            
            panContainerView?.accessibilityPerformEscape()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertNil(presenterViewController?.presentedViewController, "panModal should have been dismissed")
                dismissDidFinish.fulfill()
            }
        }
        
        wait(for: [presentDidFisnish, dismissDidFinish], timeout: 10)
    }
}
