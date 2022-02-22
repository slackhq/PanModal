//
//  SampleViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 10/9/18.
//  Copyright © 2018 PanModal. All rights reserved.
//

import UIKit

/// Allow touches to go through containerView which `isUserInteractionEnabled` is false.
private class HitTestView: UITableView {
    weak var hitTestDelegateView: UIView?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let delegateView = hitTestDelegateView, delegateView.superview != nil {
            if let view = delegateView.hitTest(convert(point, to: delegateView), with: event) {
                return view
            }
        }

        return super.hitTest(point, with: event)
    }
}

class SampleViewController: UITableViewController {

    private let hitTestView = HitTestView()

    override func loadView() {
        self.tableView = hitTestView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "PanModal"

        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Lato-Bold", size: 17)!
        ]

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)

        guard let rowType = RowType(rawValue: indexPath.row) else {
            return cell
        }
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = rowType.presentable.string
        cell.textLabel?.font = UIFont(name: "Lato-Regular", size: 17.0)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let rowType = RowType(rawValue: indexPath.row) else {
            return
        }
        dismiss(animated: true, completion: nil)
        let vc = rowType.presentable.rowVC
        hitTestView.hitTestDelegateView = vc.view
        presentPanModal(vc)
    }
}

protocol RowPresentable {
    var string: String { get }
    var rowVC: UIViewController & PanModalPresentable { get }
}

private extension SampleViewController {

    enum RowType: Int, CaseIterable {
        case basic
        case fullScreen
        case alert
        case transientAlert
        case userGroups
        case stacked
        case navController


        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .fullScreen: return FullScreen()
            case .alert: return Alert()
            case .transientAlert: return TransientAlert()
            case .userGroups: return UserGroup()
            case .stacked: return Stacked()
            case .navController: return Navigation()
            }
        }

        struct Basic: RowPresentable {
            let string: String = "Basic"
            let rowVC: PanModalPresentable.LayoutType = BasicViewController()
        }

        struct FullScreen: RowPresentable {
            let string: String = "Full Screen"
            let rowVC: PanModalPresentable.LayoutType = FullScreenNavController()
        }

        struct Alert: RowPresentable {
            let string: String = "Alert"
            let rowVC: PanModalPresentable.LayoutType = AlertViewController()
        }

        struct TransientAlert: RowPresentable {
            let string: String = "Alert (Transient)"
            let rowVC: PanModalPresentable.LayoutType = TransientAlertViewController()
        }

        struct UserGroup: RowPresentable {
            let string: String = "User Groups"
            let rowVC: PanModalPresentable.LayoutType = UserGroupViewController()
        }

        struct Navigation: RowPresentable {
            let string: String = "User Groups (NavigationController)"
            let rowVC: PanModalPresentable.LayoutType = NavigationController()
        }

        struct Stacked: RowPresentable {
            let string: String = "User Groups (Stacked)"
            let rowVC: PanModalPresentable.LayoutType = UserGroupStackedViewController()
        }
    }
}
