//
//  DummyData.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import UIKit

struct MockData: DiaryDataManagerProtocol {
    var diaryItems: [DiaryModel]?
    
    var diaryItem: [DiaryData]?

    init() {
        let data = NSDataAsset(name: "testSample")

        self.diaryItem = decode(data: data?.data ?? Data())
    }
}
