import UIKit

extension UIColor {
    enum Palette {
        static var surface: UIColor {
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
                default:
                    return UIColor.white
                }
            }
        }
        
        static var gray100: UIColor {
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 33/255, green: 36/255, blue: 37/255, alpha: 1.0)
                default:
                    return UIColor(red: 245/255, green: 246/255, blue: 248/255, alpha: 1.0)
                }
            }
        }
    }
}
