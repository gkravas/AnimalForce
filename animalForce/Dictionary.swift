//
//  Dictionary.swift
//  animalForce
//
//  Created by George Kravas on 14/01/16.
//  Copyright © 2016 George Kravas. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
