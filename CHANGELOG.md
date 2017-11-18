# 4.2

* Now we use `UIScreenEdgePanGestureRecognizer` instead of `UIPanGestureRecognizer` to prevent undexpected behavor of `UITableView`, `UIScrollView`, `UISlider` and another scrollable controls

# 4.1

* Swift Package Manager support
* Fixed bug with frame of top view controller

# 4.0.0

* Migrated to Swift 3
* Removed `SideViewControllerTrailingIndent` property. Use `sideMenuWidth` property instead.

# 3.0.0

* Now it's possible to choose side where sibedar view controller appears from. Please the the PR #14 (https://github.com/alexkrzyzanowski/SidebarOverlay/pull/14). Thanks to [Eugene Mozharovsky](https://github.com/Mozharovsky).

# 2.1.2

* Close sidebar menu on pan gesture also

# 2.1

* Now the top view controller is covered by transparent view when sidebar appears

# 2.0.3

* `UIViewController` class extension moved to a new file and fully documented
* Documentation for a few properties of `SOContainerViewController`

# 2.0.2

* Code improvements for `UIViewController` class extension
* Documentation for `UIViewController` class extension

# 2.0.1

* Documentation improvements

# 2.0

* New API introduced
* Code test coverage
* Community infrastructure
* Another fixes and improvements


# 1.3.3

* Documentation fixes


# 1.3.2

* Fucking verioning fix. I have to automate it


# 1.3.1

* Protocol extension marked as public


# 1.3.0

* Top view controller appearence fix
* Delegate can handle events when top and left view controllers will or did set


# 1.2.1

* Pan gesture direction lock


# 1.2.0

* Project integrated to Travis CI
* Now container view controller is the gesture recognizer delegate
* Example application extended with menu items


# 1.1.2

* Getting started guide in README


# 1.1.1

* Minimal README file
* so_container() method is deprecated. Use so_containerViewController property instead.


# 1.1.0

Initial release.
