import UIKit

public typealias OverContextPanModal = UIViewController & OverContextPanModalPresentable

public class OverContextNavigationController: UINavigationController {
    private weak var panModal: OverContextPanModal?
    
    init(panModal: OverContextPanModal) {
        self.panModal = panModal
        super.init(nibName: nil, bundle: nil)
        
        isNavigationBarHidden = true
        modalPresentationStyle = .overCurrentContext
        view.backgroundColor = .clear
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        panModal?.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        panModal?.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        panModal?.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        panModal?.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        panModal?.viewDidDisappear(animated)
    }
}
