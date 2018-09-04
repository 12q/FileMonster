//
//  CalculateHashOperation.swift
//  FileMonster
//
//  Created by Slava Plis on 9/5/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

class CalculateHashOperation: FileOperation {
    private var kvo: NSKeyValueObservation?
    private var progress: Progress
    private var result: [File] = []
    
    init(with content: [File]) {
        self.progress = Progress(totalUnitCount: Int64(content.count))
        super.init(with: content, type: .hash)
    }
    
    override func main() {
        setProgressObserving()
        
        for file in content {
            if progress.isCancelled { break }
            print(file.hashValue)
            result.append(file)
            if let idx = content.index(of: file) {
                progress.completedUnitCount = Int64(idx + 1)
            }
        }
    }
}

extension CalculateHashOperation {
    override func cancel() {
        progress.cancel()
        super.cancel()
    }
}

// MARK: -  KVO

extension CalculateHashOperation {
    private func setProgressObserving() {
        kvo = progress.observe(\.fractionCompleted) { [unowned self] (progress, change) in
            print(progress.fractionCompleted)
            self.delegate?.didUpdateProgress(fractionCompleted: progress.fractionCompleted)
        }
    }
}
