import UIKit

open class PanCustomTopView: UIView {
    
}

extension UIView {
    var panCustomTopView: PanCustomTopView? {
        return subviews.compactMap({ $0 as? PanCustomTopView }).first
    }
}
