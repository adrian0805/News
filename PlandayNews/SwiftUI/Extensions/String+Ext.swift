//
//  String+Ext.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 09.03.2021.
//

import Foundation

extension String {
    var localized: String{
        return Bundle.main.localizedString(forKey: self, value: nil, table: "Localizable")
    }
}
