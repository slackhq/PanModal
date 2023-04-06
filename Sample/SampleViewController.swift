//
//  SampleViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 10/9/18.
//  Copyright © 2018 PanModal. All rights reserved.
//

import UIKit

class SampleViewController: UITableViewController {

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
		guard let _ = RowType(rawValue: indexPath.row)?.presentable.image else {
			return 60.0
		}
        return 120.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)


        guard let rowType = RowType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }


		cell.textLabel?.textAlignment = .center
		cell.textLabel?.text = rowType.presentable.string
		cell.textLabel?.font = UIFont(name: "Lato-Regular", size: 17.0)
		cell.imageView?.image = rowType.presentable.image
		return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let rowType = RowType(rawValue: indexPath.row) else {
            return
        }
        dismiss(animated: true, completion: nil)
		if let _ = rowType.presentable.image {
			let vc = ImagePreviewViewController(previewView: tableView.cellForRow(at: indexPath)?.imageView)
			presentPanModal(vc)
		} else {
			presentPanModal(rowType.presentable.rowVC)
		}
    }
}

protocol RowPresentable {
    var string: String { get }
	var image: UIImage? { get }
    var rowVC: UIViewController & PanModalPresentable { get }
}

extension RowPresentable {
	var image: UIImage? {
		nil
	}
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
		case imagePreview


        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .fullScreen: return FullScreen()
            case .alert: return Alert()
            case .transientAlert: return TransientAlert()
            case .userGroups: return UserGroup()
            case .stacked: return Stacked()
            case .navController: return Navigation()
			case .imagePreview: return  ImagePreview()
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

		struct ImagePreview: RowPresentable {
			let string: String = "ImagePreview"
			let rowVC: PanModalPresentable.LayoutType = ImagePreviewViewController()

			var image: UIImage? {
				UIImage(named: "WhatsNew")
			}
		}
    }
}
