//
//  TransientAlertViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 3/1/19.
//  Copyright © 2019 Detail. All rights reserved.
//

import UIKit

class TransientAlertViewController: AlertViewController {

    private weak var timer: Timer?
    private var countdown: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.titleLabel.text = "Transient Alert"
        updateMessage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.countdown -= 1
            self?.updateMessage()
        }
    }

    @objc func updateMessage() {
        guard countdown > 0 else {
            invalidateTimer()
            dismiss(animated: true, completion: nil)
            return
        }
        alertView.message.text = "Message disppears in \(countdown) seconds"
    }

    func invalidateTimer() {
        timer?.invalidate()
    }

    deinit {
        invalidateTimer()
    }

    // MARK: - Pan Modal Presentable

    override var showDragIndicator: Bool {
        return false
    }

    override var anchorModalToLongForm: Bool {
        return true
    }

    override var panModalBackgroundColor: UIColor {
        return .clear
    }

    override var isUserInteractionEnabled: Bool {
        return false
    }
}
