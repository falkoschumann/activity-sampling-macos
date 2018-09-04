//
//  AppDelegate.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 28.08.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        App.shared.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        App.shared.stop()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
