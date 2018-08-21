//
//  FileLoader.swift
//  FileMonster
//
//  Created by Slava Plis on 8/14/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol Loader {
    func load(path: URL)
}

class FileLoader {
    private let manager = FileManager()
    private let store = DataStore.shared

    func load(path: URL) {
        let paths = contentsOf(folder: path)
        store.set(paths: paths)
    }

    func contentsOf(folder: URL) -> [URL] {
        do {
            // WARNING: SHOULD BE NESTED
            let contents = try manager.contentsOfDirectory(atPath: folder.path)
            return contents.map { return folder.appendingPathComponent($0) }
        } catch {
            return []
        }
    }
}

extension FileLoader: Loader {}
