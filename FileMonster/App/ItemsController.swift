//
//  ItemsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class ItemsController: NSViewController {

    @IBOutlet weak var contentsTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ItemsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.identifier.rawValue == "names" {
            return "name"
        }
        
        if tableColumn?.identifier.rawValue == "props" {
            return "prop"
        }
        
        return "Look down the code"
    }
}

