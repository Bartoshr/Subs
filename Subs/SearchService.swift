//
//  SearchService.swift
//  Subs
//
//  Created by Bartosh on 13.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation
import Cocoa

open class SearchService {
    
    var method : (([String])->Void)?
    
    @objc open func handleServices(_ pboard: NSPasteboard!,
        userData: String!, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
            
            let sound = NSSound(named: "hero")
            sound?.play()
            
            if (pboard.types?.contains(NSFilenamesPboardType) != nil) {
                if let fileArray = pboard.propertyList(forType: NSFilenamesPboardType) as? [String] {
                    method!(fileArray)
                }
            }
            
    }
    
}
