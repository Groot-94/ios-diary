//
//  DiaryDataManager.swift
//  Diary
//
//  Created by 변재은 on 2022/08/22.
//

import Foundation

protocol DiaryDataManagerProtocol {
    var diaryItems: [DiaryDTO]? { get set }
}

extension DiaryDataManagerProtocol {
    func decode(data: Data) -> [DiaryDTO]? {
        guard let decodedData = try? JSONDecoder().decode([DiaryDTO].self,
                                                          from: data) else { return nil }

        return decodedData
    }
}
