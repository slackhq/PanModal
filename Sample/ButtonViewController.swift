import UIKit

final class ButtonViewController: UIViewController, PanModalPresentable {
    
    var panScrollable: UIScrollView? { nil }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc
    func buttonTapped() {
        
        print("button tapped")
        
        presentPanModal(UserGroupViewController())
    }
}
