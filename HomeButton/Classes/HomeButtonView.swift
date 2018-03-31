//
// HomeButton
// Created by Nathan Gitter and Ian McDowell
//

import UIKit
import AudioToolbox

public class HomeButtonView: UIControl {
    
    // MARK: - Public API
    
    /// The style of home button.
    public var style: HomeButtonStyle = .classic {
        didSet {
            updateStyle()
        }
    }
    
    // MARK: - UI Elements
    
    /// The squircle path that resembles an app icon. Only appears for classic styles.
    private var iconPath: UIBezierPath {
        let iconWidth = size.width * 0.35
        let pathOffset = (bounds.width - iconWidth) / 2
        return UIBezierPath(roundedRect: CGRect(x: pathOffset, y: pathOffset, width: iconWidth, height: iconWidth), cornerRadius: iconWidth * 0.2)
    }
    
    /// The shape layer to draw the icon path.
    private lazy var iconShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = iconPath.cgPath
        layer.lineWidth = 2
        layer.fillColor = nil
        return layer
    }()
    
    private lazy var modernBorderImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    /// MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        createSystemSounds()
        layer.addSublayer(iconShapeLayer)
        addSubview(modernBorderImageView)
        updateStyle()
    }
    
    // MARK: - Sizing and Layout
    
    private let size = CGSize(width: 62, height: 62)
    
    public override var intrinsicContentSize: CGSize {
        return size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        iconShapeLayer.frame = bounds
        iconShapeLayer.path = iconPath.cgPath
        modernBorderImageView.frame = bounds
    }
    
    // MARK: - Touch Actions
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        handleTouch(touch: touch)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        handleTouch(touch: touch)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        handleTouch(touch: touch)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        shouldActivateOnRelease = false
    }
    
    /// The amount of 3D Touch pressure required to press the button.
    private let activationForce: CGFloat = 4.5
    
    /// The amount of 3D Touch pressure required to activate the button after it is pressed.
    /// This value should be slightly smaller than the `activationForce` to simulate a physical button.
    private let releaseForce: CGFloat = 3.5
    
    /// `true` when the button is pressed, and should activate when the pressure is lessened.
    private var shouldActivateOnRelease = false
    
    /// Haptic for button press.
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    /// Haptic for button release.
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    private func handleTouch(touch: UITouch) {
        if !shouldActivateOnRelease {
            // button has yet to be pressed
            if touch.force > activationForce {
                shouldActivateOnRelease = true
                impactFeedbackGenerator.impactOccurred()
                playPressSound()
            }
        } else {
            // button is pressed in
            backgroundColor = style.isWhite ? UIColor(white: 0.9, alpha: 1) : UIColor(white: 0, alpha: 1)
            if touch.force < releaseForce || touch.phase == .ended {
                backgroundColor = style.isWhite ? .white : UIColor(white: 0.1, alpha: 1)
                shouldActivateOnRelease = false
                feedbackGenerator.selectionChanged()
                playReleaseSound()
                activate()
            }
        }
    }
    
    private func activate() {
        // -[UIApplication suspend] gracefully closes app.
        // If selector is available, use that. Otherwise, call exit()
        let suspendSelector = NSSelectorFromString("suspend")
        if UIApplication.shared.responds(to: suspendSelector) {
            UIApplication.shared.perform(suspendSelector)
        } else {
            exit(EXIT_SUCCESS)
        }
    }
    
    // MARK: - Styling
    
    private let motionEffect = ShineMotionEffect()
    
    private func updateStyle() {
        
        iconShapeLayer.isHidden = !style.isClassic
        iconShapeLayer.strokeColor = style.isWhite ? UIColor(white: 0.85, alpha: 1).cgColor : UIColor(white: 0.5, alpha: 1).cgColor
        
        backgroundColor = style.isWhite ? HomeButtonStyle.offWhite : UIColor(white: 0.1, alpha: 1)
        layer.borderColor = style.isWhite ? UIColor(white: 0.75, alpha: 1).cgColor : UIColor(white: 0.15, alpha: 1).cgColor
        layer.borderWidth = style.isClassic ? 2 : 0
        
        guard
            let bundleURL = Bundle(for: HomeButtonView.self).url(forResource: "HomeButton", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let whiteImagePath = bundle.path(forResource: "modern_white", ofType: "png"),
            let whiteImage = UIImage(contentsOfFile: whiteImagePath),
            let blackImagePath = bundle.path(forResource: "modern_black", ofType: "png"),
            let blackImage = UIImage(contentsOfFile: blackImagePath)
        else { print("Image assets not found"); return }
        modernBorderImageView.image = style.isWhite ? whiteImage : blackImage
        modernBorderImageView.isHidden = style.isClassic
        
        // motion effect for modern style only
        if style.isClassic {
            removeMotionEffect(motionEffect)
        } else {
            addMotionEffect(motionEffect)
        }
        
    }
    
    // MARK: - Sound Effects
    
    private var pressSoundID: SystemSoundID = 0
    private var releaseSoundID: SystemSoundID = 1
    
    private func createSystemSounds() {
        guard
            let bundleURL = Bundle(for: HomeButtonView.self).url(forResource: "HomeButton", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let pressSoundUrl = bundle.url(forResource: "press", withExtension: "wav"),
            let releaseSoundUrl = bundle.url(forResource: "release", withExtension: "wav")
        else { print("Audio not found"); return }
        AudioServicesCreateSystemSoundID(pressSoundUrl as CFURL, &pressSoundID)
        AudioServicesCreateSystemSoundID(releaseSoundUrl as CFURL, &releaseSoundID)
    }
    
    private func playPressSound() {
        AudioServicesPlaySystemSound(pressSoundID)
    }
    
    private func playReleaseSound() {
        AudioServicesPlaySystemSound(releaseSoundID)
    }
    
}

private class ShineMotionEffect: UIMotionEffect {
    
    override func keyPathsAndRelativeValues(forViewerOffset viewerOffset: UIOffset) -> [String : Any]? {
        let rotation = (viewerOffset.horizontal + viewerOffset.vertical) * 0.5
        return ["transform.rotation.z": rotation]
    }
    
}
