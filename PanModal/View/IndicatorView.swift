import UIKit

class IndicatorView: UIView {
    let indicator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addIndicatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addIndicatorView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    private func addIndicatorView() {
        indicator.layer.cornerRadius = 2
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
