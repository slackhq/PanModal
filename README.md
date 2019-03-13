<p align="center">
    <img src="https://github.com/slackhq/PanModal/raw/master/Screenshots/panModal.gif" width="30%" height="30%" alt="Screenshot Preview" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Platform-iOS_10+-green.svg" alt="Platform: iOS 10.0+" />
    <a href="https://developer.apple.com/swift" target="_blank"><img src="https://img.shields.io/badge/Language-Swift_4-blueviolet.svg" alt="Language: Swift 4" /></a>
    <a href="https://cocoapods.org/pods/PanModal" target="_blank"><img src="https://img.shields.io/badge/CocoaPods-v1.0-red.svg" alt="CocoaPods compatible" /></a>
    <a href="https://github.com/Carthage/Carthage" target="_blank"><img src="https://img.shields.io/badge/Carthage-compatible-blue.svg" alt="Carthage compatible" /></a>
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT" />
</p>

<p align="center">
    <a href="#features">Features</a>
  • <a href="#compatibility">Compatibility</a>
  • <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#documentation">Documentation</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#authors">Authors</a>
  • <a href="#license">License</a>
</p>

## Features

* Supports any type of `UIViewController`
* Seamless transition between modal and content
* Maintains 60 fps performance

## Compatibility

PanModal requires **iOS 10+** and is compatible with **Swift 4.2** projects.

## Installation

* <a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>:

```ruby
pod 'PanModal'
```

* <a href="https://github.com/Carthage/Carthage" target="_blank">Carthage</a>:

```ruby
github "slackhq/PanModal"
```

## Usage

PanModal was designed to be used effortlessly. Simply call `presentPanModal` in the same way you would expect to present a `UIViewController`

```swift
.presentPanModal(yourViewController)
```

The presented view controller must conform to `PanModalPresentable` to take advantage of the customizable options

```swift
extension YourViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
}
```

### PanScrollable

If the presented view controller has an embedded `UIScrollView` e.g. as is the case with `UITableViewController`, panModal will seamlessly transition pan gestures between the modal and the scroll view

```swift
class TableViewController: UITableViewController, PanModalPresentable {

    var panScrollable: UIScrollView? {
        return tableView
    }
}
```

### Adjusting Heights

Height values of the panModal can be adjusted by overriding `shortFormHeight` or `longFormHeight`

```swift
var shortFormHeight: PanModalHeight {
    return .contentHeight(300)
}

var longFormHeight: PanModalHeight {
    return .maxHeightWithTopInset(40)
}
```

### Updates at Runtime

Values are stored during presentation, so when adjusting at runtime you should call `panModalSetNeedsLayoutUpdate()`

```swift
func viewDidLoad() {
    hasLoaded = true

    panModalSetNeedsLayoutUpdate()
    panModalTransition(to: .shortForm)
}

var shortFormHeight: PanModalHeight {
    if hasLoaded {
        return .contentHeight(200)
    }
    return .maxHeight
}
```

### Sample App

Check out the [Sample App](https://github.com/slackhq/PanModal/tree/master/Sample) for more complex configurations of `PanModalPresentable`, including navigation controllers and stacked modals.

## Documentation
Option + click on any of PanModal's methods or notes for detailed documentation.

<p align="left">
    <img src="https://github.com/slackhq/PanModal/blob/master/Screenshots/documentation.png" width="50%" height="50%" alt="Screenshot Preview" />
</p>

## Contributing

We're glad to be open sourcing this library. We use it in numerous places within the slack app and expect it to be easy to use as well as modify; we've added extensive documentation within the code to support that.

We will only be fixing critical bugs, thus, for any non-critical issues or feature requests we hope to be able to rely on the community using the library to add what they need. For more information, please read the [contributing guidelines](https://github.com/slackhq/PanModal/blob/master/CONTRIBUTING.md).

## Authors

[Stephen Sowole](https://github.com/tun57) • [Tosin Afolabi](https://github.com/tosinaf)

## License

<b>PanModal</b> is released under a MIT License. See LICENSE file for details.
