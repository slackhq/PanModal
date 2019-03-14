//
//  UserGroupViewController.swift
//  PanModal
//
//  Created by Tosin Afolabi on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import UIKit

class UserGroupViewController: UITableViewController, PanModalPresentable, UIGestureRecognizerDelegate {

    let members: [UserGroupMemberPresentable] = [
        UserGroupMemberPresentable(name: "Naida Schill ✈️", role: "Staff Engineer - Mobile DevXP", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1)),
        UserGroupMemberPresentable(name: "Annalisa Doty", role: "iOS Engineer - NewXP", avatarBackgroundColor: #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1)),
        UserGroupMemberPresentable(name: "Petra Gazaway 🏡", role: "Senior iOS Product Engineer - Enterprise", avatarBackgroundColor: #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1)),
        UserGroupMemberPresentable(name: "Jermaine Gill ⛷", role: "Staff Engineer - Mobile Infra", avatarBackgroundColor: #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1)),
        UserGroupMemberPresentable(name: "Juana Brooks 🚌", role: "Staff Software Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)),
        UserGroupMemberPresentable(name: "Stacey Francis 🛳", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.8784313725, green: 0.8745098039, blue: 0.9921568627, alpha: 1)),
        UserGroupMemberPresentable(name: "Frederick Vargas", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1)),
        UserGroupMemberPresentable(name: "Michele Owens", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1)),
        UserGroupMemberPresentable(name: "Freda Ramsey", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1)),
        UserGroupMemberPresentable(name: "Anita Thomas", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1)),
        UserGroupMemberPresentable(name: "Leona Lane", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)),
        UserGroupMemberPresentable(name: "Chad Roy", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.8784313725, green: 0.8745098039, blue: 0.9921568627, alpha: 1)),
        UserGroupMemberPresentable(name: "Joan Guzman", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1)),
        UserGroupMemberPresentable(name: "Mike Yates", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.7176470588, green: 0.8784313725, blue: 0.9882352941, alpha: 1)),
        UserGroupMemberPresentable(name: "Elbert Wilson", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9725490196, green: 0.937254902, blue: 0.4666666667, alpha: 1)),
        UserGroupMemberPresentable(name: "Anita Thomas", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9490196078, green: 0.7568627451, blue: 0.9803921569, alpha: 1)),
        UserGroupMemberPresentable(name: "Leona Lane", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.6980392157, alpha: 1)),
        UserGroupMemberPresentable(name: "Chad Roy", role: "Senior iOS Engineer", avatarBackgroundColor: #colorLiteral(red: 0.8784313725, green: 0.8745098039, blue: 0.9921568627, alpha: 1)),
        UserGroupMemberPresentable(name: "Naida Schill", role: "Staff Engineer - Mobile DevXP", avatarBackgroundColor: #colorLiteral(red: 0.7215686275, green: 0.9098039216, blue: 0.5607843137, alpha: 1))
    ]

    var isShortFormEnabled = true

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let headerView = UserGroupHeaderView()

    let headerPresentable = UserGroupHeaderPresentable.init(handle: "ios-engs", description: "iOS Engineers", memberCount: 10)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MARK: - View Configurations

    func setupTableView() {

        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
        tableView.register(UserGroupMemberCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserGroupMemberCell
            else { return UITableViewCell() }

        cell.configure(with: members[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.configure(with: headerPresentable)
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Pan Modal Presentable

    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        let bottomOffset = presentingViewController?.bottomLayoutGuide.length ?? 0
        return UIEdgeInsets(top: headerView.frame.size.height, left: 0, bottom: bottomOffset, right: 0)
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerView.frame.contains(location)
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
            else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }

}
