//
//  main.swift
//  underscore
//
//  Created by yi zythum on 14/11/18.
//  Copyright (c) 2014年 yi zythum. All rights reserved.
//

import Foundation

class Person {
    var age:Int
    var name:String
    init (age:Int, name:String){
        self.name = name
        self.age = age
    }
}
let array      = [
    Person(age: 11, name: "张三"),
    Person(age: 12, name: "李四"),
    Person(age: 13, name: "王五")
]
let dictionary = [
    "张三": Person(age: 11, name: "张三"),
    "李四": Person(age: 12, name: "李四"),
    "王五": Person(age: 13, name: "王五")
]

//let v:AnyObject = __(array).map ({ (item, index) -> AnyObject in
//    return item
//}).first()!

let v = [1,"2","3"].reverse()


println(v)

