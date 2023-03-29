//
//  PassthroughView.swift
//  PanModal
//
//  Created by VLADIMIR LEVTSOV on 21.11.2022.
//  Copyright © 2022 Detail. All rights reserved.
//

import UIKit

class PassthroughView: UIView {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
	return subviews.contains(where: {
	  !$0.isHidden
	  && $0.isUserInteractionEnabled
	  && $0.point(inside: self.convert(point, to: $0), with: event)
	})
  }
}
