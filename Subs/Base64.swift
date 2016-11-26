//
//  Misc.swift
//  Subs
//
//  Created by Bartosh on 08.03.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation

extension String {
    
    func base64Encoded() -> String {
        let plainData = data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func base64Decoded() -> String {
        let decodedData = Data(base64Encoded: self, options:NSData.Base64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: String.Encoding.utf16.rawValue)
        return decodedString as! String
    }
}
