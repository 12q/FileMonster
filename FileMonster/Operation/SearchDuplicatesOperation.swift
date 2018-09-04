//
//  SearchDuplicatesOperation.swift
//  FileMonster
//
//  Created by Slava Plis on 8/30/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

class SearchDuplicatesOperation: FileOperation {
    private var kvo: NSKeyValueObservation?
    private var manager = FileManager()
    private var progress: Progress
    private var result: [File] = []
    
    init(with content: [File]) {
        self.progress = Progress(totalUnitCount: Int64(content.count))
        super.init(with: content, type: .duplicates)
    }
    
    override func main() {
        setProgressObserving()
        
        for file in content {
            if progress.isCancelled { break }
            
            let res = content.filter {
                manager.contentsEqual(atPath: file.path.path, andPath: $0.path.path)
            }
            if res.count > 1 { result.append(contentsOf: res) }
            if let idx = content.index(of: file) {
                progress.completedUnitCount = Int64(idx + 1)
            }
        }
    }
}

extension SearchDuplicatesOperation {
    override func cancel() {
        progress.cancel()
        super.cancel()
    }
}

// MARK: -  KVO

extension SearchDuplicatesOperation {
    private func setProgressObserving() {
        kvo = progress.observe(\.fractionCompleted) { [unowned self] (progress, change) in
            print(progress.fractionCompleted)
            self.delegate?.didUpdateProgress(fractionCompleted: progress.fractionCompleted)
        }
    }
}
