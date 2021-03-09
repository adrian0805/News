//
//  Font+Ext.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import SwiftUI

extension Font {
    static func SFDisplayRegularFont(with size: CGFloat) -> Font {
        return .custom("SFProDisplay-Regular", size: size)
    }
    
    static func SFDisplayLightFont(with size: CGFloat) -> Font {
        return .custom("SFProDisplay-Light", size: size)
    }
    
    static func SFDisplayBoldFont(with size: CGFloat) -> Font {
        return .custom("SFProDisplay-Bold", size: size)
    }
}
