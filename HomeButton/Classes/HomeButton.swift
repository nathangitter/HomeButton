
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

    public static func add(to application: UIApplication) {
        // Get first window
        guard let window = application.keyWindow ?? application.windows.first else { fatalError("No windows found in application.") }

        let frame = CGRect(x: 0, y: window.bounds.height - barHeight, width: window.bounds.width, height: barHeight)
        let buttonWindow = UIWindow(frame: frame)
        buttonWindow.windowLevel = UIWindowLevelStatusBar
        buttonWindow.isHidden = false
        buttonWindow.rootViewController = HomeButtonBarViewController()
        HomeButton.buttonWindow = buttonWindow
    }

    private class HomeButtonBarViewController: UIViewController {

        override func loadView() {
            let container = UIView()
            container.backgroundColor = .darkGray

            let button = HomeButtonView()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.style = .modern
            container.addSubview(button)
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            self.view = container
        }
    }
}
