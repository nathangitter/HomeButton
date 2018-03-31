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
