
import UIKit

// Hack to add home button at boot without any modification to AppDelegate code
extension UIApplication {

    static var addedButton: Bool = false
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        if !UIApplication.addedButton {
            UIApplication.addedButton = true
            HomeButton.add(to: self)
        }
        return super.next
    }

}

public struct HomeButton {
    
    static let barHeight: CGFloat = 90

    static var buttonWindow: UIWindow?

    /// Adds the home button to the application.
    /// This function is called automatically by linking the framework.
    public static func add(to application: UIApplication) {
        // Get status bar to determine if running in a "modern" style. Do nothing otherwise.
        let statusBarSelector = NSSelectorFromString("statusBar")
        if application.responds(to: statusBarSelector) {
            let statusBar = application.perform(statusBarSelector).takeUnretainedValue()
            if statusBar.classForCoder != NSClassFromString("UIStatusBar_Modern") {
                return
            }
        }

        // Get first window
        guard let window = application.keyWindow ?? application.windows.first else { fatalError("No windows found in application.") }

        let frame = CGRect(x: 0, y: window.bounds.height - barHeight, width: window.bounds.width, height: barHeight)
        let buttonWindow = UIWindow(frame: frame)
        buttonWindow.windowLevel = UIWindowLevelStatusBar
        buttonWindow.isHidden = false
        buttonWindow.rootViewController = HomeButtonBarViewController()
        HomeButton.buttonWindow = buttonWindow
    }
    
    public static var style: HomeButtonStyle = .modern {
        didSet {
            guard let homeButtonBarViewController = buttonWindow?.rootViewController as? HomeButtonBarViewController else { return }
            homeButtonBarViewController.homeButton.style = style
            homeButtonBarViewController.containerView.backgroundColor = style.isWhite ? .white : .black
        }
    }

    private class HomeButtonBarViewController: UIViewController {
        
        public let homeButton = HomeButtonView()
        public let containerView = UIView()

        override func loadView() {
            containerView.backgroundColor = .black
            homeButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(homeButton)
            NSLayoutConstraint.activate([
                homeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                homeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            self.view = containerView
        }
    }
}
