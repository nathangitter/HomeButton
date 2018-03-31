//
// HomeButton
// Created by Nathan Gitter and Ian McDowell
//

import Foundation

public enum HomeButtonStyle {
    case classic
    case classicWhite
    case modern
    case modernWhite
}

extension HomeButtonStyle {
    
    var isWhite: Bool {
        return [.classicWhite, .modernWhite].contains(self)
    }
    
    var isClassic: Bool {
        return [.classic, .classicWhite].contains(self)
    }
    
}

extension HomeButtonStyle {
    
    /// The color of the white iPhone.
    internal static let offWhite = UIColor(red: 249 / 255, green: 251 / 255, blue: 252 / 255, alpha: 1)
    
}
