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
    func didUpdate()
}

class OperationQueueFactory {
    static func `default`() -> OperationQueue {
        let queue = OperationQueue()
        queue.name = "com.mobndev.filemonster.queue"
        queue.maxConcurrentOperationCount = 5
        print("get com.mobndev.filemonster.queue")
        return queue
    }
}

// MARK: - Operation Stack - Init

class OperationStack {
    /// Wraper around the native OperationQueue
    ///`default` implementation for a stack that keeps operation queue
    /// 5 parallel operations by default
    
    public weak var delegate: OperationStackDelegate?
    
    static let shared = OperationStack.default
    
    open static var `default`: OperationStack {
        return OperationStack(concurentOperations: 5)
    }

    let concurentOperations: Int
    var count: Int {
        return stack.operations.count
    }
    
    var stack: OperationQueue = OperationQueueFactory.default()
    
    init(concurentOperations: Int) {
        self.concurentOperations = concurentOperations
    }
}

// MARK: - OperationStack - Interface

//enum Result<T, E:Error> {
//    case success(T)
//    case failure(E)
//}

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
    
    public func currentCount() -> Int {
        return stack.operations.count
    }
    
    public func currentOperations() -> [FileOperation]? {
        if let fileOperations = stack.operations as? [FileOperation] {
            return fileOperations
        }
        return []
    }
}

// MARK: - OperationStack - Delegate

extension OperationStack {
    func didUpdate() {
        delegate?.didUpdate()
    }
}
