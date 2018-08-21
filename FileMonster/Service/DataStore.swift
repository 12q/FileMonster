//
//  DataContainer.swift
//  FileMonster
//
//  Created by Slava Plis on 8/21/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol DataContainerDelegate {
    func didUpdate()
}

class DataContainer {
    static let shared = DataContainer()
    
    private var objects: [File] = []
    
    func insert(paths: [URL]) {
        let files = paths.map { return File(with: $0) }
        objects.append(contentsOf: files)
    }
    
    func fetch() -> [File] {
        return objects
    }
}
