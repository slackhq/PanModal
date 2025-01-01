import UIKit
import Combine

class BorderCoordinator {
    private var cancellables = Set<AnyCancellable>()
    private var borderView: UIView?
    private weak var borderCoordinatorAdaptable: BorderCoordinatorAdaptable?

    init(borderCoordinatorAdaptable: BorderCoordinatorAdaptable) {
        self.borderCoordinatorAdaptable = borderCoordinatorAdaptable

        let scrollView = borderCoordinatorAdaptable.scrollView
        let yOffset = borderCoordinatorAdaptable.yOffset
        
        scrollView.publisher(for: \.contentOffset)
            .removeDuplicates()
            .map { $0.y >= yOffset }
            .removeDuplicates()
            .sink { [weak self] isShowingBorder in
                if isShowingBorder {
                    self?.showBorder()
                } else {
                    self?.hideBorder()
                }
            }
            .store(in: &cancellables)
    }

    private func showBorder() {
        if let navigationBar = borderCoordinatorAdaptable?.targetView as? UINavigationBar {
            navigationBar.showNavigationBarBorder()
        } else {
            appendBorder()
        }
    }

    private func hideBorder() {
        if let navigationBar = borderCoordinatorAdaptable?.targetView as? UINavigationBar {
            navigationBar.hideNavigationBarBorder()
        } else {
            borderView?.removeFromSuperview()
        }
    }

    private func appendBorder() {
        if borderView == nil {
            borderView = UIView()
            borderView?.backgroundColor = .Palette.gray100
            borderView?.translatesAutoresizingMaskIntoConstraints = false
        }

        guard let borderView = borderView,
            let targetView = borderCoordinatorAdaptable?.targetView else { return }

        borderView.removeFromSuperview()
        targetView.addSubview(borderView)
        targetView.sendSubviewToBack(borderView)
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
    }
}

protocol BorderCoordinatorAdaptable: AnyObject {
    var scrollView: UIScrollView { get }
    var yOffset: CGFloat { get }
    var targetView: UIView { get }
}

extension BorderCoordinatorAdaptable {
    var yOffset: CGFloat {
        return 1
    }
}

extension UINavigationBar {
    func hideNavigationBarBorder() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = barTintColor
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            standardAppearance.shadowColor = .clear
            standardAppearance.backgroundColor = barTintColor
        }
    }
    
    func showNavigationBarBorder() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = .Palette.gray100
            appearance.backgroundColor = barTintColor
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            standardAppearance.shadowColor = .Palette.gray100
            standardAppearance.backgroundColor = barTintColor
        }
    }
}
