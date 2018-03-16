
import UIKit

public struct HomeButton {
    static let BarHeight: CGFloat = 80

    static var buttonWindow: UIWindow?

    public static func add(to application: UIApplication) {
        // Get first window
        guard let window = application.keyWindow ?? application.windows.first else { fatalError("No windows found in application.") }

        let frame = CGRect(x: 0, y: window.bounds.height - BarHeight, width: window.bounds.width, height: BarHeight)
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
