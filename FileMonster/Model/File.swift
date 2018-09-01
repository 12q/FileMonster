//
//  File.swift
//  FileMonster
//
//  Created by Slava Plis on 8/20/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation
import Cocoa

enum ManagableType {
    case file
    case dir
}

let attributes = [URLResourceKey.effectiveIconKey,
                  URLResourceKey.contentModificationDateKey,
                  URLResourceKey.fileSizeKey,
                  URLResourceKey.isDirectoryKey]

struct File: Equatable {
    private var type: ManagableType
    let path: URL
    let name: String
    let ext: String
    
    var icon: NSImage?
    var date: Date?
    var size: Int64?
    var isFolder: Bool?
    
    init(with path: URL) {
        self.name = path.lastPathComponent
        self.ext = path.pathExtension
        self.type = .file
        self.path = path
        
        guard let props = fetchFileAttributes(path: path) else { return }
        
        self.icon = props[URLResourceKey.effectiveIconKey] as? NSImage
        self.date = props[URLResourceKey.contentModificationDateKey] as? Date
        self.size = props[URLResourceKey.fileSizeKey] as? Int64
        self.isFolder = props[URLResourceKey.isDirectoryKey] as? Bool
    }

    private func fetchFileAttributes(path: URL) -> [URLResourceKey : Any]? {
        do {
            let props = try (path as NSURL).resourceValues(forKeys: attributes)
            return props
        } catch {
            print("Opps, can't get props for: \(path)")
            return nil
        }
    }
    
    static func ==(lhs: File, rhs: File) -> Bool {
        return lhs.name == rhs.name && lhs.ext == rhs.ext
    }
}
