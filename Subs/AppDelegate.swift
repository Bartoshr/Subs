//
//  AppDelegate.swift
//  Subs
//
//  Created by Bartosh on 05.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Cocoa
import PathKit


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableControler: TableControler!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func application(sender: NSApplication, printFile filename: String) -> Bool {
        print("file \(filename)")
        return true
    }
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        
        for filename in filenames {
            
            let filePath = Path(filename).lastComponent
            print(filePath)
            
            tableControler.search(filename)
            tableControler.directory = "/Users/bartosh/Desktop/paczka.gz"
        }
        
    }

}

