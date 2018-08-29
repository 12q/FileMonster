//
//  OperationsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class OperationsController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

enum OperationType {
    case duplicates, sort
    
    func name() -> String {
        switch self {
        case .sort:
            return "Filter by Name"
        case .duplicates:
            return "Searching for duplicates"
//        case .SortByMake:
//            return "Categorize images"
        default:
            return "No Option"
        }
    }
}

extension OperationType {
    static var allValues: [OperationType] {
        return [.duplicates, .sort]
    }
}

extension OperationsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return OperationType.allValues.count
    }
}

extension  OperationsController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OperationCell"), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue =  OperationType.allValues[row].name()
            return cell
        }
        return nil
    }
}


