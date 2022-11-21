//
//  KeyboardPolicy.swift
//  PanModal
//
//  Created by VLADIMIR LEVTSOV on 07.11.2022.
//  Copyright © 2022 Detail. All rights reserved.
//

import Foundation
import UIKit

public enum KeyboardPolicy {
	case ignore
	case switchToLongForm
	case switchToLongFormWithPinndedView(additionOffset: CGFloat)
}
