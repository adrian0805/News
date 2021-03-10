//
//  Images.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation
import SwiftUI

enum Images {
    case clock
    case backImage
    case news
    
    func getImage() -> Image {
        switch self {
        case .clock:
            return Image(systemName: "clock")
        case .backImage:
            return Image(systemName: "chevron.backward")
        case .news:
            return Image("news")
        }
    }
}
