//
//  AnyTransition.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//
import SwiftUI

extension AnyTransition {
    static var bottomTrailing: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(with: .move(edge: .trailing))
    }
}

