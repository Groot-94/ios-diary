//
//  DefaultContainer.swift
//  Diary
//
//  Created by NAMU on 2022/08/28.
//

import CoreData

class DefaultContainer {
    let modelName: String
    let entityName: String
    
    init(modelName: String, entityName: String) {
        self.modelName = modelName
        self.entityName = entityName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
}
