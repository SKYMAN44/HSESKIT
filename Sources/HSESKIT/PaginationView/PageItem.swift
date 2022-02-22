//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 22.02.2022.
//

import Foundation

public struct PageItem {
    var title: String
    var notifications: Int
//    var action: ((String) -> ())?
    
    public init(title: String, notifications: Int) {
        self.title = title
        self.notifications = notifications
    }
}
