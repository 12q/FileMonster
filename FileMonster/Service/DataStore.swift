//
//  DataStore.swift
//  FileMonster
//
//  Created by Slava Plis on 8/21/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol DataStoreDelegate: AnyObject {
    func didUpdate(content: [File])
}

class DataStore {
    weak var delegate: DataStoreDelegate?
    static let shared = DataStore()
    private var content: [File] = []
    
    /// Converts the lits of URLs into objects
    /// - Parameter drain: The bool that just points whether we keeps pervious elements or not
    func set(paths: [URL], drain: Bool) {
        if drain { content.removeAll() }
        
        let files = paths.map { return File(with: $0) }
        content.append(contentsOf: files)
        delegate?.didUpdate(content: content)
    }
    
    func fetch() -> [File] {
        return content
    }
}
