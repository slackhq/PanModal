//
//  PanModalFormParameter.swift
//  PanModalDemo
//
//  Created by Влада Кузнецова on 30.05.23.
//  Copyright © 2023 Detail. All rights reserved.
//

#if os(iOS)
import Foundation

public class PanModalFormParameter<T: PanModalMixable>  {
	let shortFormValue: T
	let longFormValue: T

	public init(
		shortFormValue: T,
		longFormValue: T
	) {
		self.shortFormValue = shortFormValue
		self.longFormValue = longFormValue
	}
}

#endif
