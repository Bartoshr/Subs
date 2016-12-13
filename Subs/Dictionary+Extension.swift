//
//  Dictionary+Extension.swift
//  Subs
//
//  Created by Bartosh on 12.12.2016.
//  Copyright © 2016 Bartosh. All rights reserved.
//

import Foundation

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    rhs.forEach{ result[$0] = $1 }
    return result
}
