//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/25.
//

import Foundation
import CoreData
import UIKit.UIApplication

class DiaryCoreDataManager: CoreDataManagerProtocol {
    typealias Entity = Diary
    
    static let shared = DiaryCoreDataManager()
    private let container = DefaultContainer(modelName: NameSpace.modelName,
                                             entityName: NameSpace.entityName)
    var persistent: ContainerType {
        .container(container)
    }
    
    private init() {}
    
    func create(newDiary: DiaryModel) {
        let keyValue = [
            NameSpace.titleKeyName: newDiary.title,
            NameSpace.bodyKeyName: newDiary.body,
            NameSpace.createdAtKeyName: newDiary.createdAt
        ] as [String: Any]
        
        createObject(entityKeyValue: keyValue)
    }
    
    func read() -> [DiaryModel]? {
        guard let fetchList = readObject(request: Diary.fetchRequest()) else { return nil }
        
        var diaryList = [DiaryModel]()
        
        fetchList.forEach { diaryList.append(DiaryModel(title: $0.title,
                                                        body: $0.body,
                                                        createdAt: $0.createdAt))}
        
        return diaryList
    }
    
    func update(diary: DiaryModel) {
        guard let diaryList = try? persistent.context.fetch(Diary.fetchRequest()),
              let diaryData = diaryList.filter({ $0.createdAt == diary.createdAt }).first
        else { return }
        
        let keyValue = [
            NameSpace.titleKeyName: diary.title,
            NameSpace.bodyKeyName: diary.body,
            NameSpace.createdAtKeyName: diary.createdAt
        ] as [String: Any]
        
        updateObject(object: diaryData, entityKeyValue: keyValue)
    }
    
    func delete(createdAt: Double) {
        guard let diaryList = try? persistent.context.fetch(Diary.fetchRequest()),
              let diaryData = diaryList.filter({ $0.createdAt == createdAt }).first
        else { return }
        
        deleteObject(object: diaryData)
    }
}

private enum NameSpace {
    static let modelName = "Diary"
    static let entityName = "Diary"
    static let titleKeyName = "title"
    static let bodyKeyName = "body"
    static let createdAtKeyName = "createdAt"
}
