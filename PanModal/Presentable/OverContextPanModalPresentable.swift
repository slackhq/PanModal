import Foundation

public protocol OverContextPanModalPresentable: PanModalPresentable {
    
}

extension OverContextPanModalPresentable where Self: UIViewController {
    var presentStyle: PanModalPresentStyle {
        return .embed
    }
    
    func panModalDidDismiss() {
        presentingViewController?.dismiss(animated: false)
    }
}
