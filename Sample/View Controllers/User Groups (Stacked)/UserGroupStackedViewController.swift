//
//  UserGroupStackedViewController.swift
//  PanModal
//
//  Created by Stephen Sowole on 2/26/19.
//  Copyright © 2019 PanModal. All rights reserved.
//

import UIKit

class UserGroupStackedViewController: UserGroupViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let presentable = members[indexPath.row]
        let viewController = StackedProfileViewController(presentable: presentable)

        presentPanModal(viewController)
    }

    override var backgroundDimBehaviour: PanModalBackgroundDimBehaviour { .dynamic }
    
    override var allowsDragToDismiss: Bool { false }
    
    override var shortFormHeight: PanModalHeight { .contentHeight(100) }
    
    override var backgroundInteraction: PanModalBackgroundInteraction { .transitionToShortFormOrForwardToRoot }
}
