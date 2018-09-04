//
//  OperationType.swift
//  FileMonster
//
//  Created by Slava Plis on 8/30/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

enum OperationType {
    case duplicates, hash
    
    func name() -> String {
        switch self {
        case .hash:
            return "Calculating Hash"
        case .duplicates:
            return "Searching for duplicates"
        }
    }
}

extension OperationType {
    static var allValues: [OperationType] {
        return [.duplicates, .hash]
    }
}
