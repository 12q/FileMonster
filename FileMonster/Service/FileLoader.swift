//
//  FileLoader.swift
//  FileMonster
//
//  Created by Slava Plis on 8/14/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

protocol Loader {
    weak var delegate: FileLoaderDelegate? { get set }
    func loadFiles(at path: URL) -> [URL]
}

protocol FileLoaderDelegate: class {
    func didLoad(data: String)
}

class FileLoader: Loader {
    private let fileManager = FileManager.default
    weak var delegate: FileLoaderDelegate?

    func loadFiles(at path: URL) -> [URL] {
        delegate?.didLoad(data: "AAA")
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
