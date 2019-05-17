//
//  UserGroupMemberCell.swift
//  PanModal
//
//  Created by Tosin Afolabi on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import UIKit

class UserGroupMemberCell: UITableViewCell {

    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        static let avatarSize = CGSize(width: 36.0, height: 36.0)
    }

    // MARK: - Properties

    var presentable = UserGroupMemberPresentable(name: "", role: "", avatarBackgroundColor: .black)

    // MARK: - Views

    let avatarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
        label.font = UIFont(name: "Lato-Bold", size: 17.0)
        label.backgroundColor = .clear
        return label
    }()

    let roleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
        label.backgroundColor = .clear
        label.font = UIFont(name: "Lato-Regular", size: 13.0)
        return label
    }()

    lazy var memberDetailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarView, memberDetailsStackView])
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
        isAccessibilityElement = true

        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1).withAlphaComponent(0.11)
        selectedBackgroundView = backgroundView

        contentView.addSubview(stackView)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    func setupConstraints() {

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.contentInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.contentInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentInsets.bottom).isActive = true

        let avatarWidthConstriant = avatarView.widthAnchor.constraint(equalToConstant: Constants.avatarSize.width)
        let avatarHeightConstraint = avatarView.heightAnchor.constraint(equalToConstant: Constants.avatarSize.height)

        [avatarWidthConstriant, avatarHeightConstraint].forEach {
            $0.priority = UILayoutPriority(UILayoutPriority.required.rawValue - 1)
            $0.isActive = true
        }
    }

    // MARK: - Highlight

    /**
     On cell selection or highlight, iOS makes all vies have a clear background
     the below methods address the issue for the avatar view
     */

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        avatarView.backgroundColor = presentable.avatarBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        avatarView.backgroundColor = presentable.avatarBackgroundColor
    }

    // MARK: - View Configuration

    func configure(with presentable: UserGroupMemberPresentable) {
        self.presentable = presentable
        nameLabel.text = presentable.name
        roleLabel.text = presentable.role
        avatarView.backgroundColor = presentable.avatarBackgroundColor
    }

}
