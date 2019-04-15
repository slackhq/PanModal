import UIKit

class IndicatorView: UIView {
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
        let indicator = UIView()
        indicator.backgroundColor = UIColor(red: 241/255.0, green: 243/255.0, blue: 245/255.0, alpha: 1)
        indicator.layer.cornerRadius = 2
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
