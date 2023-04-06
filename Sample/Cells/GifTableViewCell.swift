//
//  GifTableViewCell.swift
//  PanModalDemo
//
//  Created by VLADIMIR LEVTSOV on 06.04.2023.
//  Copyright © 2023 Detail. All rights reserved.
//

import UIKit

class GifTableViewCell: UITableViewCell {

	private let gifView: UIImageView = {
		let view = UIImageView()
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
		addSubview(gifView)

		NSLayoutConstraint.activate([
			gifView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
			gifView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
			gifView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
			gifView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])

	}

	func setUrl(_ url: String) {
		gifView.image = UIImage.gifImageWithURL(url)
	}

}
