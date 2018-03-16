// todo header comment here

import UIKit

public enum HomeButtonStyle {
    case classic
    case classicWhite
    case modern
    case modernWhite
}

@IBDesignable
public class HomeButton: UIControl {
    
    /// The style of home button.
    public var style: HomeButtonStyle = .modern {
        didSet {
            updateStyle()
        }
    }
    
    private lazy var iconPath: UIBezierPath = {
        let iconWidth = size.width * 0.75
        return UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: iconWidth, height: iconWidth), cornerRadius: iconWidth * 0.2)
    }()
    
    private lazy var iconShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = iconPath.cgPath
        layer.borderWidth = 2
        return layer
    }()
    
    private let size = CGSize(width: 50, height: 50) // 10.9mm?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
        updateStyle()
    }
    
    public override var intrinsicContentSize: CGSize {
        return size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundColor = .black
    }
    
    @objc private func touchUpInsideAction() {
        exit(0)
    }
    
    private func updateStyle() {
        
        switch style {
        case .classic:
            ()
        case .classicWhite:
            ()
        case .modern:
            ()
        case .modernWhite:
            ()
        }
        
        backgroundColor = .black
        
    }
    
}
