//
//  ItemsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class ItemsController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var selectButton: NSButton!
    
    private var fileLoader: Loader?
    private let store = DataStore.shared

    var content: [File] = []

    // Service Dependency
    func set(loadService: Loader) {
        self.fileLoader = loadService
    }
    
    // User Dialog
    @IBAction func selectFolder(_ sender: Any) {
        showDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - File Open Panel

extension ItemsController {
    func showDialog() {
        let dialog = NSOpenPanel()
        dialog.title = "Select Path"
        dialog.message = "Please, select the Folder which shoud be processed by matched operations above."
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let selectedPath = dialog.url {
                guard let loader = fileLoader else { return }
                loader.load(path: selectedPath)
            }
        }
    }
}

// MARK: -  Table View Delegate

extension ItemsController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return content.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let file = content[row]
        
        if tableColumn?.identifier.rawValue == "names" {
            return file.name
        }
        
        if tableColumn?.identifier.rawValue == "props" {
            return file.path
        }
        return "Check identifier for Cell ;P"
    }
}

