//
//  ViewController.swift
//  FileMonster
//
//  Created by Slava Plis on 7/27/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var open: NSButton!
    
    var filesList: [File] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func selectFolder(_ sender: Any) {
        let dialog = NSOpenPanel()
        dialog.title = "Select"
        dialog.allowsMultipleSelection = true
        dialog.canChooseDirectories = true
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let result = dialog.url {
                encodeToTree(result)
                tableView.reloadData()
            }
        } else {
            return
        }
    }
    
    let fileManager = FileManager.default

    func contentsOf(folder: URL) -> [URL] {
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
            let urls = contents.map { return folder.appendingPathComponent($0) }
            return urls
        } catch {
            return []
        }
    }
    
    func encodeToTree(_ basePath: URL) {
        var tree = RefTree()
        
        let content = contentsOf(folder: basePath)
        
        content.map({
            if $0.hasDirectoryPath {
                tree.insert(Dir(at: $0))
            } else {
                tree.insert(File(at: $0))
            }
        })
    }
}

//var isDirectory = ObjCBool(true)
//let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
//return exists && isDirectory.boolValue

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filesList.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = filesList[row]

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: nil) as? NSTableCellView {
//            cell.textField?.stringValue = item.exten
            return cell
        }
        return nil
    }
}

enum ManagableType {
    case file
    case dir
}

protocol Managable {
    var path: URL { get }
    var type: ManagableType { get }
}

struct File: Managable {
    internal var type: ManagableType
    internal var path: URL
    let name: String
    let ext: String
    
    init(at path: URL) {
        self.name = path.lastPathComponent
        self.ext = path.pathExtension
        self.type = .file
        self.path = path
    }
}

struct Dir: Managable {
    internal var type: ManagableType
    internal var path: URL
    var name: String
    
    init(at path: URL) {
        self.path = path
        self.type = .dir
        self.name = path.lastPathComponent
    }
}

public struct RefTree {
    private var content: [Managable] = []
    
    mutating func insert(_ element: Managable) {
        content.append(element)
        print(element)
    }
}

/// Main operations
///     Search
///     Find Duplications
///     Flat the subfolders
///     Sort    
///

