//
//  AppDelegate.swift
//  Subs
//
//  Created by Bartosh on 05.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Cocoa
import PathKit
import Alamofire
import AlamofireXMLRPC

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableControler: TableControler!
    
    let userAgent =  "OSTestUserAgent";
    let host = "https://api.opensubtitles.org:443/xml-rpc"
    
    var openSubtitles : OpenSubtitles
    
    var token : String = ""
    var subtitles : [Subtitle] = []
    
    let emptySound = NSSound(named: "Hero")
    

    override init() {
        openSubtitles = OpenSubtitles(host: host, userAgent: userAgent)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        openSubtitles.logIn(logedIn);
        tableControler.rowSelectedMethod = download
    }
    
    // Actions
    
    func search(path: String){
        openSubtitles.searchSubtitles(self.token,
            path: path,
            properties: nil,
            callback:searchComlpeted)
    }
    
    func download(id: String){
        let props = [id] as XMLRPCArray
        openSubtitles.downloadSubtitles(token,
            ids: props,
            callback: downloadCompleted)
    }
    
    // Callbacks
    
    func logedIn(token: String){
        self.token = token
        print(token)
    }
    
    func searchComlpeted(data: [Subtitle])->Void {
        
        if data.count == 0 {
            emptySound?.play()
            return
        }
        
        window.makeKeyAndOrderFront(self)
        tableControler.subtitles = data
        tableControler.tableView.reloadData()
        
    }
    
    
    func downloadCompleted(data: [String])->Void {
        let decodedData = NSData(base64EncodedString: data[0], options:NSDataBase64DecodingOptions(rawValue: 0))
        let decompressedData : NSData = try! decodedData!.gunzippedData()
        decompressedData.writeToFile(tableControler.directory!+"paczka.srt", atomically: true)
    }
    
    // Application Handlers

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func application(sender: NSApplication, printFile filename: String) -> Bool {
        print("file \(filename)")
        return true
    }
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        
        for filename in filenames {
            let directory = Path(filename).parent()
            print(directory.description)
            search(filename)
            tableControler.directory = directory.description+"/"
        }
        
    }
    

}

