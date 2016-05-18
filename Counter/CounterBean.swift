//
//  CounterBean.swift
//  Counter
//
//  Created by RaghuKV on 5/10/15.
//  Copyright (c) 2015 RaghuKV. All rights reserved.
//

import Foundation

class CounterBean {
    var count = 0;
    var label = "default";
    var increment = 1;
    var decrement = 1;
    
    convenience init (initialCount : Int, label: String){
        self.init()
        self.count = initialCount
        self.label = label
    }
    
    convenience init (initialCount : Int, label: String, increment: Int, decrement : Int){
        self.init()
        self.count = initialCount
        self.label = label
        self.increment = increment
        self.decrement = decrement
    }

}