//
//  FileLoader.swift
//  FileMonster
//
//  Created by Slava Plis on 8/14/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol Loader {
    func load(_ path: URL) -> [URL]
}

class FileLoader: Loader {
    private let fileManager = FileManager.default

    func load(_ path: URL) -> [URL] {
        return contentsOf(folder: path)
    }

    func contentsOf(folder: URL) -> [URL] {
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
            let urls = contents.map { return folder.appendingPathComponent($0) }
            return urls
        } catch {
            return []
        }
    }
}
