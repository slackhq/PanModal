//
//  AlertViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    private let alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
        alertView.layer.cornerRadius = 20.0
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        layoutAlertView()
        layoutLabel()
    }

    private func layoutAlertView() {
        view.addSubview(alertView)

        alertView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        if #available(iOS 11.0, *) {
            let constant: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom == 0 ? -20 : 0
            alertView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        } else {
            alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        }
    }

    private func layoutLabel() {
        let label = UILabel()

        label.text = "THIS IS AN EXAMPLE ALERT"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "Lato-Bold", size: 16.0)

        alertView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: alertView.centerYAnchor).isActive = true
    }
}

extension AlertViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(100)
    }

    var longFormHeight: PanModalHeight {
        return shortFormHeight
    }

    var backgroundAlpha: CGFloat {
        return 0.1
    }

    var shouldRoundTopCorners: Bool {
        return false
    }

    var showDragIndicator: Bool {
        return true
    }
}
