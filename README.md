# ADCoordinator

![CI](https://github.com/faberNovel/Coordinator/workflows/CI/badge.svg?branch=master)
[![Version](https://img.shields.io/cocoapods/v/ADCoordinator.svg?style=flat)](https://cocoapods.org/pods/ADCoordinator)
[![License](https://img.shields.io/cocoapods/l/ADCoordinator.svg?style=flat)](https://cocoapods.org/pods/ADCoordinator)
[![Platform](https://img.shields.io/cocoapods/p/ADCoordinator.svg?style=flat)](https://cocoapods.org/pods/ADCoordinator)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

ADCoordinator is written in Swift 5.1. Compatible with iOS 10.0+.

## Installation

ADCoordinator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ADCoordinator'
```

## Architecture

Each coordinator is instantiated with a graphical context **it does not own**. For instance a coordinator can be initialized with a `UIWindow` or `UINavigationController`.

```swift
class ApplicationCoordinator: Coordinator {
    private unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
```

*Note*: the `unowed` here is mandatory to avoid retaining the UIKit object.

The coordinator is then responsible to create and display view controllers inside this graphical context.

As a convention, we use a method named `start` to tell the coordinator to create its first view controller:

```swift
class ApplicationCoordinator: Coordinator, MasterViewControllerDelegate {
    ...

    // MARK: - Public

    func start() {
        let viewController = MasterViewController()
        // the view controller can notify the coordinator when it needs to navigate
        viewController.delegate = self
        // display the first view controller in the navigation controller
        navigationController.pushViewController(viewController, animated: false)
        // Automatic memory management
        bindToLifecycle(of: viewController)
    }
}
```

The outside world is responsible to create and display the graphical context on screen.

In this case the `AppDelegate` will create a `navigationController` and set it to its window `rootViewController`.

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        // Create the graphical context
        let navigationController = UINavigationController()
        // Create the coordinator with the graphical context
        applicationCoordinator = ApplicationCoordinator(navigationController: navigationController)
        // Let the coordinator display its content
        applicationCoordinator?.start()

        // Present the graphical context on screen
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return true
    }
}
```

## Navigation

Once we want to change the view controller on screen, we ask the coordinator. **No navigation is allowed outside the coordinator.**

Either we push a view controller *horizontally* (meaning on the same navigation controller stack) or present a view controller *vertically* (meaning on another navigation controller that comes on top).

### Horizontally

When the coordinator receives a callback from the view controller on screen to navigate, the simplest way is just to create a new view controller and push it onto the navigation stack.

```swift
class ApplicationCoordinator: Coordinator, MasterViewControllerDelegate {
    ...

    // MARK: - MasterViewControllerDelegate

    func masterViewControllerDidRequestPush() {
        let detailViewController = DetailViewController()
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
```

### Vertically

In this case it means creating a new graphical context (most of the time a navigation controller) and displaying it on top.

**Rule of thumbs**: create a new coordinator each time the method `UIViewController.present(_:animated:completion)` is called.

```swift
class DetailCoordinator: Coordinator {

    private unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start() {
        let viewController = DetailViewController()
        navigationController.pushViewController(viewController, animated: false)
        // Automatic memory management
        bindToLifecycle(of: viewController)
    }
}
```

This is always the same idea, the coordinator is given a graphical context it does not own and perform  actions inside it. This is the parent coordinator that creates the graphical context and the child coordinator.

```swift
class ApplicationCoordinator: Coordinator, MasterViewControllerDelegate {
    ...

    // MARK: - MasterViewControllerDelegate

    func masterViewControllerDidRequestPresent() {
        // The new graphical context for the child coordinator
        let navigationController = UINavigationController()
        // Create the child coordinator
        let coordinator = DetailCoordinator(navigationController: navigationController)
        // Add child to the tree of coordinators
        addChild(coordinator)
        // Start the coordinator
        coordinator.start()
        // Present the new graphical context on screen
        self.navigationController.present(navigationController, animated: true)
    }
}
```

## Memory Management

### Basics

Each time a new coordinator is created, it has to be retained by another object. The root coordinator is retained by the `AppDelegate` and each coordinator stores an array of children coordinators.
A coordinator can retain a child coordinator calling the `addChild` method and can remove a child from its `children` array with the `removeChild` method.

```swift
class Coordinator {
    private(set) var children: [Coordinator] = []
    private(set) weak var parent: Coordinator?

    func addChild(_ coordinator: Coordinator) { ... }
    func removeChild(_ coordinator: Coordinator) { ... }
}
```

### Automatic child removal

Since iOS 13, a new modal presentation has been introduced. The presentation does not cover the entire screen, and more importantly, the user can dismiss the modal swipping down, without any callback to the view controller.

We saw earlier that each modal presented leads to the creation of a new coordinator. Once the modal is dismissed, the associated coordinator should be released. If the user taps a button, an action is associated to this button, and the view controller can forward the intent to the right coordinator to call `removeChild`. But if the user swipes down a modal on iOS 13, no action is triggered.

To overcome this issue, each coordinator should call `bindToLifecyle(of:)` passing the view controller it is bound to as parameter.

```swift
class DetailCoordinator: Coordinator {
    ...

    // MARK: - Public

    func start() {
        let viewController = DetailViewController()
        navigationController.pushViewController(viewController, animated: false)
        bindToLifecycle(of: viewController)
    }
}
```

This method will then observe the lifecycle of `viewController`, and once it has been deallocated, will ask the parent coordinator to automatically call `removeChild`. This way the child coordinator will be deallocated at the same time its graphical context does.

*Note*: the same pattern can be applied in an horizontal navigation, when you want to extract duplicated code into a coordinator. When the user hits the pop button in a navigation bar, no action is triggered in your app. So you have to use `bindToLifecycle(of:)` with the view controller you want to observe the pop.

### Using `bindToLifecycle(of:)`

Choosing the right object to pass to the `bindToLifecycle(of:)` is the key to good memory management.
If a coordinator is initialized with a navigation controller, you should observe the first view controller the coordinator pushes on the stack. That way:
- when the navigation controller is released, so does the view controller, and the coordinator is notified
- if the view controller was not the first in the stack and the user pops, then the view controller is released, and once again, the coordinator is notified
- if you want to change the navigation controller stack, you can call `bindToLifecycle(of:)` with another view controller, to remove the previous observer and create a new one

## Authors

- [@PierreFelgines](https://twitter.com/pierrefelgines)
- [@laviallb](https://twitter.com/laviallb)

## License

ADCoordinator is available under the MIT license. See the LICENSE file for more info.
