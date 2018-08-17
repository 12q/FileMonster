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
        // Do view setup here.
    }
    
}

extension OperationsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
    }
}

extension  OperationsController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OperationCell"), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "OperationCell"
            return cell
        }
        return nil
    }
}


