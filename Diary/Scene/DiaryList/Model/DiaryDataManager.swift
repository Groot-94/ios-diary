//
//  DiaryDataManager.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/25.
//

import Foundation

protocol DiaryManager { //모든 매니저가 CRUD 필요, 그래서 DiaryManager로 추상화
    
    func create(_ diaryInfo: DiaryProtocol)
    func read(createdAt: Double) -> DiaryProtocol?
    func update(_ diaryInfo: DiaryProtocol) -> DiaryProtocol?
    func delete(createdAt: Double)
    func readAll() -> [DiaryProtocol]?
}

protocol DiaryProtocol { //Diary type을 추상화시킴 , DiaryModel 이랑 CoreData 왜냐면 coreData에 있는 entity를 직접 뷰컨에 갖다 쓸 수 없음 (가능은 한데, decodable 채택해서 쓸 거 아니니까) 
    var title: String { get }
    var body: String { get }
    var createdAt: Double { get }
}

