//
//  ItemsController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class ItemsController: NSViewController, NSTableViewDataSource, FileLoaderDelegate {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var selectButton: NSButton!
    
    private var fileLoader: Loader? {
        didSet {
            fileLoader?.delegate = self
        }
    }
    var content: [File] = []

    // Service Dependency
    func set(loadService: Loader) {
        self.fileLoader = loadService
        
    }
    
    // User Dialog
    @IBAction func selectFolder(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Select Path"
        dialog.message = "Please, select the Folder which shoud be processed by matched operations above."
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let selectedPath = dialog.url {
                guard let loader = fileLoader else { return }
                self.content = loader.load(at: selectedPath)
                print(content.count)
                tableView.reloadData()

            }
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -
    func didLoad(data: [File]) {
        content = data
        print(content.count)
        tableView.reloadData()
        print(content.count)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        print("tbable: \(content.count)")

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

//// MARK: - Data Content Service Delegate
//
//extension ItemsController:  {
//    func didLoad(data: [File]) {
//        contents.append(contentsOf: data)
//        contentsTableView.reloadData()
//    }
//}

// MARK: -  Table View Delegate

//extension ItemsController: NSTableViewDataSource {
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return contents.count
//    }
//
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        let file = contents[row]
//
//        if tableColumn?.identifier.rawValue == "names" {
//            return file.name
//        }
//
//        if tableColumn?.identifier.rawValue == "props" {
//            return file.path
//        }
//
//        return "Check identifier for Cell ;P"
//    }
//}

