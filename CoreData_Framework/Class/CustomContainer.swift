//
//  CustomContainer.swift
//  Diary
//
//  Created by NAMU on 2022/08/28.
//

import CoreData

class CustomContainer {
    private let modelName: String
    private let modelExtension: String
    private let storeDirectory: FileManager.SearchPathDirectory
    private let storeDomainMask: FileManager.SearchPathDomainMask
    let entityName: String
    
    init(modelName: String,
         modelExtension: String,
         storeDirectory: FileManager.SearchPathDirectory,
         storeDomainMask: FileManager.SearchPathDomainMask,
         entityName: String) {
        self.modelName = modelName
        self.modelExtension = modelExtension
        self.storeDirectory = storeDirectory
        self.storeDomainMask = storeDomainMask
        self.entityName = entityName
    }
    
    var context: NSManagedObjectContext {
        makeManagedObjectContext()
    }
    
    private func makeManagedObjectContext() -> NSManagedObjectContext {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: modelExtension)
        else {
            fatalError("Failed to find data model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Failed to create model from file: \(modelURL)")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let dirURL = FileManager.default.urls(for: storeDirectory, in: storeDomainMask ).last
        let fileURL = URL(string: "\(entityName).sql", relativeTo: dirURL)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: fileURL, options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
