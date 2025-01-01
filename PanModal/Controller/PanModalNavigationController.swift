import UIKit

public class PanModalNavigationController: UINavigationController, PanModalPresentable {
    public var panScrollable: UIScrollView? {
        return mTopPanModalPresentable?.panScrollable
    }
    public var longFormHeight: PanModalHeight {
        return mTopPanModalPresentable?.longFormHeight ?? .maxHeight
    }
    public var shortFormHeight: PanModalHeight {
        return mTopPanModalPresentable?.shortFormHeight ?? longFormHeight
    }
    public var panCustomTopView: PanCustomTopView? {
        return mTopPanModalPresentable?.panCustomTopView
    }
    public var allowsTapToDismiss: Bool {
        return mTopPanModalPresentable?.allowsTapToDismiss ?? true
    }
    public var allowsDragToDismiss: Bool {
        return mTopPanModalPresentable?.allowsDragToDismiss ?? true
    }
    public var indicatorColor: UIColor {
        return mTopPanModalPresentable?.indicatorColor ?? UIColor(red: 241/255.0, green: 243/255.0, blue: 245/255.0, alpha: 1)
    }
    public var panModalBackgroundColor: UIColor {
        UIColor.black.withAlphaComponent(0.7)
    }

    public var dragIndicatorBackgroundColor: UIColor { .Palette.surface }

    public var allowsExtendedPanScrolling = true
    // 16: IndicatorView Size, 56: IndicatorView를 제외한 상단 마진
    // IndicatorView는 TopOffset에 포함되어 있지 않음
    // 만약 IndicatorView를 상단에 붙이고 싶으면 topOffset값은 16이 되어야 한다.
    public var topOffset = CGFloat(56 + 16)

    private var mIsInteractiveBack = false
    private var mPushedControllerBeforeViewLoaded = [UIViewController]()
    private var mLastStateStore = [Int: PanModalPresentationState]()
    private var mTopPanModalPresentable: PanModalPresentable? {
        return topViewController as? PanModalPresentable
    }
    private var borderCoordinator: BorderCoordinator?

    public override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        view.backgroundColor = .Palette.surface
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .Palette.surface
        navigationBar.hideNavigationBarBorder()

        mPushedControllerBeforeViewLoaded.forEach { pushViewController($0, animated: false) }
        mPushedControllerBeforeViewLoaded.removeAll()
        borderCoordinator = BorderCoordinator(borderCoordinatorAdaptable: self)
    }

    public override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)

        mIsInteractiveBack = vc?.transitionCoordinator?.isInteractive ?? false
        if !mIsInteractiveBack {
            panModalSetNeedsLayoutUpdate()
        }
        return vc
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !isViewLoaded {
            mPushedControllerBeforeViewLoaded.append(viewController)
        } else {
            super.pushViewController(viewController, animated: animated)
            panModalSetNeedsLayoutUpdate()
        }
    }

    public func willTransition(to state: PanModalPresentationState) {
        if let topControllerHashValue = topViewController?.hashValue {
            mLastStateStore[topControllerHashValue] = state
        }
    }

    public func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return mTopPanModalPresentable?.shouldRespond(to: panModalGestureRecognizer) ?? true
    }

    func panModalSetNeedsLayoutUpdate() {
        presentedVC?.setNeedsLayoutUpdate()
        adjustPanModalState()
    }

    fileprivate func adjustPanModalState() {
        panModalTransition(to: mLastStateStore[(topViewController ?? self).hashValue] ?? .shortForm)
    }
    
    public func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) {
        if let presentable = topViewController as? PanModalPresentable {
            presentable.willRespond(to: panModalGestureRecognizer)
        }
    }
    
    public func panModalWillDismiss() {
        if let presentable = topViewController as? PanModalPresentable {
            presentable.panModalWillDismiss()
        }
    }
}

extension PanModalNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if mIsInteractiveBack {
            panModalSetNeedsLayoutUpdate()
        }
    }
}

extension PanModalNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension PanModalNavigationController: BorderCoordinatorAdaptable {
    public var scrollView: UIScrollView {
        return panScrollable ?? UIScrollView()
    }

    public var targetView: UIView {
        return navigationBar
    }
}
