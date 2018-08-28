//
//  TodoStruct.swift
//  GetTheGist
//
//  Created by kristina on 8/27/18.
//  Copyright © 2018 kristina. All rights reserved.
//

import Foundation

struct Todo {
    var title: String
    var id: Int?
    var userId: Int
    var completed: Bool
    
    init?(title: String, id: Int?, userId: Int, completedStatus: Bool) {
        self.title = title
        self.id = id
        self.userId = userId
        self.completed = completedStatus
    }
    
    func description() -> String {
        return "ID: \(self.id ?? 0), " +
        "User ID: \(self.userId)" +
        "Title: \(self.title)\n" +
        "Completed: \(self.completed)\n"
    }
}
