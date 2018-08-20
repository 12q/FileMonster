//
//  FileLoader.swift
//  FileMonster
//
//  Created by Slava Plis on 8/14/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

///
protocol Loader {
    var delegate: FileLoaderDelegate? { get set }
    func load(at path: URL) -> [File]
}

///
protocol FileLoaderDelegate: AnyObject {
    func didLoad(data: [File])
}

class FileLoader: Loader {
    weak var delegate: FileLoaderDelegate?
    private let fileManager = FileManager.default
    
    
    func load(at path: URL) -> [File] {
        let paths = contentsOf(folder: path)
        let files = paths.map { return File(with: $0) }
//        delegate?.didLoad(data: files)
        return files
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
