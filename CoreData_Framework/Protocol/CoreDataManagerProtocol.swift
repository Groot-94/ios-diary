//
//  CoreDataManagerProtocol.swift
//  Diary
//
//  Created by NAMU on 2022/08/27.
//

import CoreData

protocol CoreDataManagerProtocol {
    associatedtype Entity
    
    var persistent: ContainerType { get }
}

extension CoreDataManagerProtocol {
    private var context: NSManagedObjectContext {
        return persistent.context
    }
    
    func createObject(entityKeyValue: [String: Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: persistent.entityName,
                                                      in: context)
        else { return }
        
        let managerObject = NSManagedObject(entity: entity, insertInto: context)
        entityKeyValue.forEach { managerObject.setValue($0.value, forKey: $0.key) }
        
        saveContext()
    }
    
    func readObject<Entity>(request: NSFetchRequest<Entity>) -> [Entity]? {
        guard let fetchList = try? context.fetch(request) as [Entity] else { return nil }
        
        return fetchList
    }
    
    func updateObject(object: NSManagedObject, entityKeyValue: [String: Any]) {
        entityKeyValue.forEach { object.setValue($0.value, forKey: $0.key) }
        
        saveContext()
    }
    
    func deleteObject(object: NSManagedObject) {
        context.delete(object)
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
