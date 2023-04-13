//
//  SampleViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 10/9/18.
//  Copyright © 2018 PanModal. All rights reserved.
//

import UIKit
import AVFoundation

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
		tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: String(describing: VideoTableViewCell.self))
		tableView.register(GifTableViewCell.self, forCellReuseIdentifier: String(describing: GifTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard let rowType = RowType(rawValue: indexPath.row) else {
			return 60
		}
		switch rowType {
		case .imagePreview, .gifPreview:
			return 80
		case .videoPreview:
			return 120
		default:
			return 60
		}
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let rowType = RowType(rawValue: indexPath.row) else {
			return UITableViewCell()
		}

		switch rowType {
		case .videoPreview:
			let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoTableViewCell.self), for: indexPath) as! VideoTableViewCell
			cell.setImage("maxresdefault")
			return cell
		case .gifPreview:
			let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GifTableViewCell.self), for: indexPath) as! GifTableViewCell
			cell.setUrl("https://gifbin.com/bin/4802swswsw04.gif")
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
			cell.textLabel?.textAlignment = .center
			cell.textLabel?.text = rowType.presentable.string
			cell.textLabel?.font = UIFont(name: "Lato-Regular", size: 17.0)
			cell.imageView?.image = rowType.presentable.image

			return cell
		}

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let rowType = RowType(rawValue: indexPath.row) else {
            return
        }
        dismiss(animated: true, completion: nil)
		switch rowType {
		case .imagePreview:
			let vc = PreviewViewController(preview: .image(sourceView: tableView.cellForRow(at: indexPath)!.imageView!, url: nil))
			presentPanModal(vc)
		case .videoPreview:
			let cell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
			let item = AVPlayerItem(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
			let vc = PreviewViewController(preview: .video(item: item, sourceView: cell.videoContainer))
			presentPanModal(vc)
		case .gifPreview:
			let cell = tableView.cellForRow(at: indexPath) as! GifTableViewCell
			let vc = PreviewViewController(preview: .gif(sourceView: cell.gifView, url: nil))
			presentPanModal(vc)
		case .loadable:
			let cell = tableView.cellForRow(at: indexPath)!
			let vc = PreviewViewController(preview: .loadable(state: download, sourceView: cell.imageView!))
			presentPanModal(vc)
		default:
			presentPanModal(rowType.presentable.rowVC)
		}
    }

	private func download(completion: @escaping ((LoadablaItemState) -> Void)) {
		completion(.loading)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
			let view = UIImageView(image: UIImage(named: "profile_preview"))
			view.contentMode = .scaleAspectFit
			completion(.loaded(view))
		})
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
		case videoPreview
		case gifPreview
		case loadable


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
			case .videoPreview: return  VideoPreview()
			case .gifPreview:  return  GifPreview()
			case .loadable: return LoadablePreview()
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
			let string: String = "Image Preview"
			let rowVC: PanModalPresentable.LayoutType = PreviewViewController()

			var image: UIImage? {
				UIImage(named: "WhatsNew")
			}
		}

		struct VideoPreview: RowPresentable {
			let string: String = "Video Preview"
			let rowVC: PanModalPresentable.LayoutType = PreviewViewController()
		}

		struct GifPreview: RowPresentable {
			let string: String = "Gif Preview"
			let rowVC: PanModalPresentable.LayoutType = PreviewViewController()
		}

		struct LoadablePreview: RowPresentable {
			let string: String = "Loadable Preview"
			let rowVC: PanModalPresentable.LayoutType = PreviewViewController()

			var image: UIImage? {
				UIImage(named: "WhatsNew")
			}
		}
    }
}
