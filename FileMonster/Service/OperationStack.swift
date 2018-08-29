//
//  OperationsContainer.swift
//  FileMonster
//
//  Created by Slava Plis on 8/17/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Foundation

// MARK: - Operation Stack - Protocol

protocol OperationStackDelegate: class {
    func didUpdate(oparations: [FileOperation])
}

// MARK: - Operation Stack - Init

class OperationStack {
    /// Wraper around the native OperationQueue
    ///`default` implementation for a stack that keeps operation queue
    /// 5 parallel operations by default
    
    public weak var delegate: OperationStackDelegate?
    
    open static var `default`: OperationStack {
        return OperationStack(concurentOperations: 5)
    }

    let concurentOperations: Int
    
    var stack: OperationQueue {
        let queue = OperationQueue()
        queue.name = "com.mobndev.filemonster.queue"
        queue.maxConcurrentOperationCount = 5
        print("get com.mobndev.filemonster.queue")
        return queue
    }

    init(concurentOperations: Int) {
        self.concurentOperations = concurentOperations
    }
}

// MARK: - OperationStack - Interface

extension OperationStack {
    func add(operation: FileOperation) {
        stack.addOperation(operation)
        didUpdate()
    }
    
    func drop(oparation: FileOperation) {
        oparation.cancel()
        didUpdate()
    }
    
    func release() {}
}

// MARK: - OperationStack - Delegate

extension OperationStack {
    func didUpdate() {
        if let fileOperations = stack.operations as? [FileOperation] {
            delegate?.didUpdate(oparations: fileOperations)
        }
    }
}






protocol OperationProgressDelegate: AnyObject {
    func didUpdateProgress(fractionCompleted: Double)
}

protocol OperationResultDelegate: AnyObject {
    func someResult()
}

//protocol FileOperation: class {
//    var type: OperationType { get }
//    weak var delegate: OperationProgressDelegate? { get set }
//}

class FileOperation: Operation {
    public weak var delegate: OperationProgressDelegate?
    public var type: OperationType
    internal var content: [File]
    
    init(with content: [File], type: OperationType) {
        self.type = type
        self.content = content
    }
}

class SearchingDuplicatesOperation: FileOperation {
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
    
    // MARK: -  KVO
    private func setProgressObserving() {
        kvo = progress.observe(\.fractionCompleted) { [unowned self] (progress, change) in
            print(progress.fractionCompleted)
            self.delegate?.didUpdateProgress(fractionCompleted: progress.fractionCompleted)
        }
    }
}
