//
//  StackedProfileViewController.swift
//  PanModal
//
//  Created by Tosin Afolabi on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import UIKit

class StackedProfileViewController: UIViewController, PanModalPresentable {

    // MARK: - Properties

    let presentable: UserGroupMemberPresentable

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Views

    let avatarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1)
        label.font = UIFont(name: "Lato-Bold", size: 20.0)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let roleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7019607843, green: 0.7058823529, blue: 0.7137254902, alpha: 1)
        label.backgroundColor = .clear
        label.font = UIFont(name: "Lato-Regular", size: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    init(presentable: UserGroupMemberPresentable) {
        self.presentable = presentable
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)

        view.addSubview(avatarView)
        view.addSubview(nameLabel)
        view.addSubview(roleLabel)

        nameLabel.text = presentable.name
        roleLabel.text = presentable.role
        avatarView.backgroundColor = presentable.avatarBackgroundColor

        setupConstraints()
    }

    // MARK: - Layoutt

    func setupConstraints() {

        avatarView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25.0).isActive = true

        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20.0).isActive = true

        roleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.0).isActive = true
        bottomLayoutGuide.topAnchor.constraint(greaterThanOrEqualTo: roleLabel.bottomAnchor).isActive = true
    }

    // MARK: - Pan Modal Presentable

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .intrinsicHeight
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    var shouldRoundTopCorners: Bool {
        return true
    }

}
