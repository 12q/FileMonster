//
//  RootWindowController.swift
//  FileMonster
//
//  Created by Slava Plis on 8/16/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

class RootWindowController: NSWindowController {

    convenience init() {
        self.init(windowNibName: NSNib.Name(rawValue: "RootWindowController"))
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let spitController = NSSplitViewController()
        
        let operationsVC = OperationsController()
        operationsVC.set(loader: FileLoader())
        
        let itemsVC = ItemsController()
        
        spitController.addSplitViewItem(NSSplitViewItem(viewController: operationsVC))
        spitController.addSplitViewItem(NSSplitViewItem(viewController: itemsVC))
        
        // Setting Up the Root Controller
        window?.contentViewController = spitController
    }
    
}
