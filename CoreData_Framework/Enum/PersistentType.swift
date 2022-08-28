//
//  PersistentType.swift
//  Diary
//
//  Created by NAMU on 2022/08/28.
//

import CoreData

enum PersistentType {
    case container(DefaultContainer)
    case custom(CustomContainer)
    
    var context: NSManagedObjectContext {
        switch self {
        case .container(let container):
            return container.context
        case .custom(let customContainer):
            return customContainer.context
        }
    }
    
    var entityName: String {
        switch self {
        case .container(let container):
            return container.entityName
        case .custom(let customContainer):
            return customContainer.entityName
        }
    }
}
