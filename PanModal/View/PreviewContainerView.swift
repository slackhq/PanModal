//
//  PreviewContainerView.swift
//  PanModal
//
//  Created by VLADIMIR LEVTSOV on 29.03.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

#if os(iOS)
import UIKit

final class PreviewContainerView: PassthroughView {

}

extension UIView {

	/**
	 Convenience property for retrieving a PreviewContainerView instance
	 from the view hierachy
	 */
	var previewContainerView: PreviewContainerView? {
		return subviews.first(where: { $0 is PreviewContainerView }) as? PreviewContainerView
	}

}
#endif
