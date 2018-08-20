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
    
    private var fileLoader: Loader?

    func set(loader: Loader) {
        self.fileLoader = loader
        self.fileLoader?.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ItemsController: FileLoaderDelegate {
    func didLoad(data: String) {
        print(data)
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
        
        return "Check identifier for Cell ;P"
    }
}

