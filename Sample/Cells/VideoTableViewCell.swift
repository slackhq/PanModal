//
//  VideoTableViewCell.swift
//  PanModalDemo
//
//  Created by VLADIMIR LEVTSOV on 06.04.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

	private let videoContainer: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .lightGray
		return view
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func commonInit() {
		addSubview(videoContainer)

		NSLayoutConstraint.activate([
			videoContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
			videoContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
			videoContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			videoContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		])

	}

}
