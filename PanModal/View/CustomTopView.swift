//
//  CustomTopView.swift
//  PanModal
//
//  Created by Hyun Sik Yoo on 2023/06/05.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit

open class CustomTopView: UIView {
    
}

extension UIView {
    var customTopView: CustomTopView? {
        return subviews.compactMap({ $0 as? CustomTopView }).first
    }
}
