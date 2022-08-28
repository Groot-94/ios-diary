//
//  CoreDataManager.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/25.
//

import Foundation
import CoreData
import UIKit.UIApplication

class CoreDataManager: DiaryManager {
    
    private var appDelegate: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate
    }
    
    private var context: NSManagedObjectContext? {
        appDelegate?.persistentContainer.viewContext
    }
    
    init() {}
    
    func create(_ diaryInfo: DiaryProtocol) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: NameSpace.entityName, in: context)
        else { return }
        
        let diary = NSManagedObject(entity: entity, insertInto: context)
        diary.setValue(diaryInfo.title, forKey: NameSpace.titleKeyName)
        diary.setValue(diaryInfo.body, forKey: NameSpace.bodyKeyName)
        diary.setValue(diaryInfo.createdAt, forKey: NameSpace.createdAtKeyName)
        
        appDelegate?.saveContext()
    }
    
    func read(createdAt: Double) -> DiaryProtocol? {
        guard let fetchList = try? context?.fetch(Diary.fetchRequest()),
              let diaryList = fetchList.filter({ $0.createdAt == createdAt }).first
        else { return nil }
        
        return diaryList
    }
    
    func readAll() -> [DiaryProtocol]? {
        guard let fetchList = try? context?.fetch(Diary.fetchRequest()) as? [Diary]
        else { return nil }
        
        var diaryList = [DiaryModel]()
        
        fetchList.forEach { diaryList.append(DiaryModel(title: $0.title,
                                                        body: $0.body,
                                                        createdAt: $0.createdAt))}
        
        return diaryList
    }
    
    @discardableResult
    func update(_ diaryInfo: DiaryProtocol) -> DiaryProtocol? {
        guard let diaryList = try? context?.fetch(Diary.fetchRequest()),
              let diaryData = diaryList.filter({ $0.createdAt == diaryInfo.createdAt }).first
        else { return nil }
        
        diaryData.setValue(diaryInfo.title, forKey: NameSpace.titleKeyName)
        diaryData.setValue(diaryInfo.body, forKey: NameSpace.bodyKeyName)
        diaryData.setValue(diaryInfo.createdAt, forKey: NameSpace.createdAtKeyName)
        
        appDelegate?.saveContext()
        
        return diaryData
    }
    
    func delete(createdAt: Double) {
        guard let diaryList = try? context?.fetch(Diary.fetchRequest()),
              let diaryData = diaryList.filter({ $0.createdAt == createdAt }).first
        else { return }
        
        context?.delete(diaryData)
        
        appDelegate?.saveContext()
    }
}

private enum NameSpace {
    static let entityName = "Diary"
    static let titleKeyName = "title"
    static let bodyKeyName = "body"
    static let createdAtKeyName = "createdAt"
}
