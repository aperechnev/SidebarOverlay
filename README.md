# SidebarOverlay

[![Travis CI](https://api.travis-ci.org/aperechnev/SidebarOverlay.svg?branch=develop)](https://travis-ci.org/aperechnev/SidebarOverlay) [![CocoaPods](https://img.shields.io/cocoapods/v/SidebarOverlay.svg)](http://cocoapods.org/pods/SidebarOverlay) ![CocoaPods](https://img.shields.io/cocoapods/p/SidebarOverlay.svg) [![CocoaDocs](https://img.shields.io/cocoapods/metrics/doc-percent/SidebarOverlay.svg)](http://cocoadocs.org/docsets/SidebarOverlay/)

`SidebarOverlay` is an implementation of sidebar menu, similar to `ECSlidingViewController`. The difference is that in `SidebarOverlay` the sidebar menu covers the top view when user opens it, like on the picture below:

![SidebarOverlay application example](https://habrastorage.org/files/812/9c0/7da/8129c07da55f4a95a110bea8eb4a8e5b.gif)

## Installation

The easiest way to start development using `SidebarOverlay` is to install it via CocoaPods. Just add it to your `Podfile`:

```Podspec
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'SidebarOverlay'
```

## Getting Started

It's quit simple to start developing with `SidebarOverlay`. First, we have to create three view controllers on our storyboard:

* container view controller
* top view controller
* left view controller

The container view controller is the root view controller that makes all magic for us. It's necessary to subclass `SOContainerViewController` and assign it to our container view controller. Then we can setup top and left view controllers:

```Swift
import SidebarOverlay

class ContainerViewController: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.topViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topScreen")
        self.leftViewController = self.storyboard?.instantiateViewControllerWithIdentifier("leftScreen")
    }

}
```

Set the container view controller as initial on your storyboard and your basic application with sidebar is ready to run.

### Open sidebar menu programatically

It's always good if user is able to open sidebar menu not only by swipe gesture, but also by tap on menu button. To open sidebar menu programatically, call `setMenuOpened(true)` method of container view controller:

```Swift
class TopViewController: UIViewController {
    
    @IBAction func showMeMyMenu () {
        if let container = self.so_containerViewController {
            container.setMenuOpened(true)
        }
    }

}
```

As you see, we have property named `so_containerViewController`. This property is automatically added to all view controllers and you're able to access it everywhere.

To close the sidebar menu, just call the `setMenuOpened(false)` method.

## How To Contribute

Please follow the [git-flow](http://danielkummer.github.io/git-flow-cheatsheet/index.html) notation and make sure that all tests are passed before contributing. Your questions and pull requests are welcome.

## Versioning

We are using [semantic versioning](http://semver.org).
