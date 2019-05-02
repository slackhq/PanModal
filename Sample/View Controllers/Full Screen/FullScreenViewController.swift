//
//  FullScreenViewController.swift
//  PanModalDemo
//
//  Created by Stephen Sowole on 5/2/19.
//  Copyright © 2019 Detail. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension FullScreenViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var topOffset: CGFloat {
        return 0.0
    }

    var springDamping: CGFloat {
        return 1.0
    }

    var shouldRoundTopCorners: Bool {
        return false
    }

    var showDragIndicator: Bool {
        return false
    }
}
