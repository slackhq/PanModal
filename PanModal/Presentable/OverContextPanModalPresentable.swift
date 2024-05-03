import Foundation

public protocol OverContextPanModalPresentable: PanModalPresentable {
    
}

extension OverContextPanModalPresentable where Self: UIViewController {
    public var presentStyle: PanModalPresentStyle {
        return .embed
    }
    
    public func panModalDidDismiss() {
        presentingViewController?.dismiss(animated: false)
    }
}
