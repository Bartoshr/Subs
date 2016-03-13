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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableControler: TableControler!
    
    let userAgent =  "OSTestUserAgent";
    let host = "https://api.opensubtitles.org:443/xml-rpc"
    
    var openSubtitles : OpenSubtitles
    var searchService: SearchService
    
    
    var token : String = ""
    var subtitles : [Subtitle] = []
    var saveDirectory: String?
    
    let emptySound = NSSound(named: "Hero")
    

    override init() {
        openSubtitles = OpenSubtitles(host: host, userAgent: userAgent)
        searchService = SearchService()
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
    
    func download(subtitle: Subtitle){
        openSubtitles.downloadSubtitles(token,
            subtitle: subtitle,
            callback: downloadCompleted)
    }
    
    // Callbacks
    
    func logedIn(token: String){
        self.token = token
        print(token)
    }
    
    func logedOut(status: String){
        print(status)
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
    
    
    func downloadCompleted(data: [String], filename: String)->Void {
        
        let decodedData = NSData(base64EncodedString: data[0], options:NSDataBase64DecodingOptions(rawValue: 0))
        let decompressedData : NSData = try! decodedData!.gunzippedData()
        decompressedData.writeToFile(saveDirectory!+filename, atomically: true)
        
    }
    
    // Application Handlers

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        openSubtitles.logOut(token, callback: logedOut)
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
            
            saveDirectory = directory.description+"/"
            
        }
        
    }
    

}

