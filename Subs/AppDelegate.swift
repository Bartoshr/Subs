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
    
    let userAgent =  "OSTestUserAgentTemp";
    let host = "https://api.opensubtitles.org:443/xml-rpc"
    
    var openSubtitles : OpenSubtitles
    var searchService: SearchService
    
    var token : String? = nil
    var subtitles : [Subtitle] = []
    
    var saveDirectory: String?
    var filename: String?
    
    let emptySound = NSSound(named: "Hero")
    
    var searchOnStartup = false;
    var filenames: [String]? = nil;
    
    override init(){
        openSubtitles = OpenSubtitles(host: host, userAgent: userAgent)
        searchService = SearchService()
        super.init()
        openSubtitles.logIn(logedIn)
        searchService.method = serviceLaunched
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        tableControler.rowSelectedMethod = download
        NSApp.servicesProvider = searchService
        NSUpdateDynamicServices()
    }
    
    // Actions
    
    func search(_ paths: [String]){
        openSubtitles.searchSubtitles(self.token!,
            paths: paths,
            properties: nil,
            callback:searchComlpeted)
    }
    
    func download(_ subtitle: Subtitle){
        openSubtitles.downloadSubtitles(token!,
            subtitle: subtitle,
            callback: downloadCompleted)
    }
    
    
    func procesFiles(_ filenames: [String]){
        let directory = Path(filenames[0]).parent()
        filename = Path(filenames[0]).lastComponent
        
        saveDirectory = directory.description+"/"
        print(directory.description)
        search(filenames)
    }
    
    // Callbacks
    
    func serviceLaunched(_ filenames: [String]){
        if(token == nil) {
            self.filenames = filenames
            searchOnStartup = true
        } else {
            procesFiles(filenames)
        }
    }
    
    func logedIn(_ token: String){
        self.token = token
        print(token)
        
        if(searchOnStartup == true) {
            procesFiles(filenames!)
            searchOnStartup = false
        }
    }
    
    func logedOut(_ status: String){
        print(status)
    }
    
    func searchComlpeted(_ data: [Subtitle])->Void {
        if data.count == 0 {
            emptySound?.play()
            return
        }
        
        window.title = filename!
        window.makeKeyAndOrderFront(self)
        tableControler.subtitles = data
        tableControler.tableView.reloadData()
    }
    
    
    func downloadCompleted(_ data: [String], filename: String)->Void {
        let decodedData = Data(base64Encoded: data[0], options:NSData.Base64DecodingOptions(rawValue: 0))
        let decompressedData : Data = try! decodedData!.gunzipped()
        try? decompressedData.write(to: URL(fileURLWithPath: saveDirectory!+filename), options: [.atomic])
        

        NSApp.terminate(self)
    }
    
    // Application Handlers

    func applicationWillTerminate(_ aNotification: Notification) {
        openSubtitles.logOut(token!, callback: logedOut)
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        procesFiles(filenames)
    }
    
    func goToPreferences()->Void {
        print("OK Works")
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let newMenu = NSMenu(title: "Menu")
        let newMenuItem = NSMenuItem(title: "Preferences", action: #selector(AppDelegate.goToPreferences), keyEquivalent: "")
        newMenuItem.tag = 1
        newMenu.addItem(newMenuItem)
        return newMenu
    }
    

}

