//
//  DataStore.swift
//  FileMonster
//
//  Created by Slava Plis on 8/21/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol DataStoreDelegate {
    func didUpdate()
}

class DataStore {
    static let shared = DataStore()
    private var content: [File] = []
    
    func set(paths: [URL]) {
        let files = paths.map { return File(with: $0) }
        content.append(contentsOf: files)
    }
    
    func fetch() -> [File] {
        return content
    }
}
