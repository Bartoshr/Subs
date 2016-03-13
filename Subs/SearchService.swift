//
//  SearchService.swift
//  Subs
//
//  Created by Bartosh on 13.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation
import Cocoa

public class SearchService {
    
    var serviceMethod : (([String])->Void)?
    
    @objc public func handleServices(pboard: NSPasteboard!,
        userData: String!, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
            
            if (pboard.types?.contains(NSFilenamesPboardType) != nil) {
                if let fileArray = pboard.propertyListForType(NSFilenamesPboardType) as? [String] {
                    serviceMethod!(fileArray)
                }
            }
            
    }
    
    init(serviceMethod : (([String])->Void)?){
        self.serviceMethod = serviceMethod
        NSApp.servicesProvider = self
        NSUpdateDynamicServices()
    }

    
}