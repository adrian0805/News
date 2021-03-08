//
//  Date+Ext.swift
//  PlandayNews
//
//  Created by Macarenco Adrian on 04.03.2021.
//

import Foundation

extension Date {
    func toString(withFormat customFormat: String = "dd MMM YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customFormat
        return dateFormatter.string(from: self)
    }
    
    func getTimeAgoString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
