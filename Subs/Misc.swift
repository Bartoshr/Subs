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
        let plainData = dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64String!
    }
    
    func base64Decoded() -> String {
        let decodedData = NSData(base64EncodedString: self, options:NSDataBase64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData!, encoding: NSUTF16StringEncoding)
        return decodedString as! String
    }
}