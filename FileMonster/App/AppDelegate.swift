//
//  AppDelegate.swift
//  FileMonster
//
//  Created by Slava Plis on 7/27/18.
//  Copyright © 2018 Slava Plis. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let rootWindowController = RootWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rootWindowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

