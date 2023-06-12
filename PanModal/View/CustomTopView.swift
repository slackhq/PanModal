import UIKit

open class CustomTopView: UIView {
    
}

extension UIView {
    var customTopView: CustomTopView? {
        return subviews.compactMap({ $0 as? CustomTopView }).first
    }
}
