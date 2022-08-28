//
//  DiaryDataManager.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/25.
//

import Foundation

protocol DiaryManager {
    
    func create(_ diaryInfo: DiaryProtocol)
    func read(createdAt: Double) -> DiaryProtocol?
    func update(_ diaryInfo: DiaryProtocol) -> DiaryProtocol?
    func delete(createdAt: Double)
}

protocol DiaryProtocol {
    var title: String { get }
    var body: String { get }
    var createdAt: Double { get }
}
