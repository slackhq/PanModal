//
//  BasicViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    private let topView = TopView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1137254902, blue: 0.1294117647, alpha: 1)
    }
}

extension BasicViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(200)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
    
    var panCustomTopView: PanCustomTopView? {
        return topView
    }
    
    var indicatorColor: UIColor {
        return .red
    }
    
    var allowsTapToDismiss: Bool {
        return false
    }
}

extension BasicViewController {
    final class TopView: PanCustomTopView {
        enum Layout {
            static let size = CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
        
        private let containerView: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 12
            containerView.layer.masksToBounds = true
            
            return containerView
        }()
        
        private let affiliateSwitch = UISwitch()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "CustomTopView Example"
            label.textColor = .black
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: .init(origin: .zero, size: Layout.size))
            
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            containerView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            containerView.addSubview(affiliateSwitch)
            affiliateSwitch.translatesAutoresizingMaskIntoConstraints = false
            affiliateSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10).isActive = true
            affiliateSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
