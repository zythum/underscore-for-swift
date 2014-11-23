//
//  underscore.swift
//  underscore
//
//  Created by yi zythum on 14/11/18.
//  Copyright (c) 2014年 yi zythum. All rights reserved.
//

import Foundation
import Darwin

public class underscore{
    
    class func each<T> (array:[T], _ iteratee:( item:T, index:Int, inout stop:Bool )->()) {
        var stop = false
        for (index, item) in enumerate(array) {
            iteratee(item: item, index: index, stop: &stop)
            if stop { break }
        }
    }
    
    class func each<T:Hashable, E> (dictionary:[T:E], _ iteratee:( value:E, key:T, inout stop:Bool )->()) {
        var stop = false
        for (key, value) in dictionary {
            iteratee(value: value, key: key, stop:&stop)
            if stop { break }
        }
    }
    
    class func map<T, E> (var array:[T], _ iteratee:(item:T, index:Int)->E)->[E] {
        var resultArray:[E] = []
        underscore.each(array, { (item, index, stop) -> () in
            resultArray.append(iteratee(item: item, index: index));
        })
        return resultArray
    }
    
    class func map<T:Hashable, E, U> (dictionary:[T:E], _ iteratee:(value:E, key:T)->U)->[T:U] {
        var resultDictionary = [T:U]();
        underscore.each(dictionary, { (value, key, stop) -> () in
            let _value = iteratee(value: value, key: key)
            resultDictionary.updateValue(_value, forKey: key)
        })
        return resultDictionary
    }
    
    class func filter<T> (array:[T], _ iteratee:(item:T, index:Int)->Bool)->[T] {
        var resultArray:[T] = [];
        underscore.each(array, { (item, index, stop) -> () in
            if iteratee(item: item, index: index) {
                resultArray.append(item)
            }
        })
        return resultArray
    }
    
    class func filter<T:Hashable, E> (dictionary:[T:E], _ iteratee:(value:E, key:T)->Bool)->[T:E] {
        var resultDictionary = [T:E]();
        underscore.each(dictionary, { (value, key, stop) -> () in
            if iteratee(value: value, key: key) {
                resultDictionary.updateValue(value, forKey: key)
            }
        })
        return resultDictionary
    }
    
    class func reject<T> (array:[T], _ iteratee:(item:T, index:Int)->Bool)->[T] {
        var resultArray:[T] = [];
        underscore.each(array, { (item, index, stop) -> () in
            if !iteratee(item: item, index: index) {
                resultArray.append(item)
            }
        })
        return resultArray
    }
    
    class func reject<T:Hashable, E> (dictionary:[T:E], _ iteratee:(value:E, key:T)->Bool)->[T:E] {
        var resultDictionary = [T:E]();
        underscore.each(dictionary, { (value, key, stop) -> () in
            if !iteratee(value: value, key: key) {
                resultDictionary.updateValue(value, forKey: key)
            }
        })
        return resultDictionary
    }
    
    class func find<E> (array:[E], _ iteratee:(item:E)->Bool)->E? {
        var result:E?
        underscore.each(array, { (item, index, stop) -> () in
            if iteratee(item: item) {
                result = item
                stop = true
            }
        })
        return result
    }
    
    class func find<T:Hashable, E> (dictionary:[T:E], _ iteratee:(item:E)->Bool)->E? {
        return underscore.find(underscore.values(dictionary), iteratee)
    }
    
    class func every<T> (array:[T], _ iteratee:( item:T )->Bool)->Bool {
        var match = true
        underscore.each(array, { (item, index, stop) -> () in
            if !iteratee(item: item) {
                match = false
                stop = true
            }
        })
        return match
    }
    
    class func every<T:Hashable, E> (dictionary:[T:E], _ iteratee:( item:E )->Bool)->Bool {
        return underscore.every(underscore.values(dictionary), iteratee)
    }
    
    class func some<T> (array:[T], _ iteratee:( item:T)->Bool)->Bool {
        var match = false
        underscore.each(array, { (item, index, stop) -> () in
            if iteratee(item: item) {
                match = true
                stop = true
            }
        })
        return match
    }
    
    class func some<T:Hashable, E> (dictionary:[T:E], _ iteratee:( value:E )->Bool)->Bool {
        return underscore.some(underscore.values(dictionary), iteratee)
    }
    
    class func max<T:Comparable> (array:[T])->T? {
        var max:T?
        underscore.each(array, { (item, index, stop) -> () in
            if max == nil || item > max { max = item }
        })
        return max
    }
    
    class func max<T, U:Comparable> (array:[T], _ iteratee:(item:T)->U)->T? {
        var maxItem:T?
        var maxValue:U?
        underscore.each(array, { (item, index, stop) -> () in
            let value = iteratee(item: item)
            if maxValue == nil || value > maxValue {
                maxItem = item
                maxValue = value
            }
        })
        return maxItem
    }
    
    class func max<T:Hashable, E:Comparable> (dictionary:[T:E])->E? {
        return underscore.max(underscore.values(dictionary))
    }
    
    class func max<T:Hashable, E, U:Comparable> (dictionary:[T:E], _ iteratee:(item:E)->U)->E? {
        return underscore.max(underscore.values(dictionary), iteratee)
    }
    class func min<T:Comparable> (array:[T])->T? {
        var min:T?
        underscore.each(array, { (item, index, stop) -> () in
            if min == nil || item < min { min = item }
        })
        return min
    }
    
    class func min<T, U:Comparable> (array:[T], _ iteratee:(item:T)->U)->T? {
        var minItem:T?
        var minValue:U?
        underscore.each(array, { (item, index, stop) -> () in
            let value = iteratee(item: item)
            if minValue == nil || value < minValue {
                minItem = item
                minValue = value
            }
        })
        return minItem
    }
    
    class func min<T:Hashable, E:Comparable> (dictionary:[T:E])->E? {
        return underscore.min(underscore.values(dictionary))
    }
    
    class func min<T:Hashable, E, U:Comparable> (dictionary:[T:E], _ iteratee:(item:E)->U)->E? {
        return underscore.min(underscore.values(dictionary), iteratee)
    }
    
    class func shuffle<T> (array:[T])->[T] {
        var resultArray = array
        for (index, item) in enumerate(array) {
            let rand = underscore.random(0, index)
            if rand != index { resultArray[index] = resultArray[rand] }
            resultArray[rand] = array[index]
        }
        return resultArray
    }
    
    class func shuffle<T:Hashable, E> (dictionary:[T:E])->[E] {
        return underscore.shuffle(underscore.values(dictionary))
    }
    
    class func sample<T> (array:[T])->T? {
        return array.count > 0 ? array[underscore.random(0, array.count-1)] : nil
    }
    
    class func sample<T> (array:[T], _ count:Int)->[T] {
        return underscore.initial(underscore.shuffle(array), array.count - count)
    }
    
    class func sample<T:Hashable, E> (dictionary:[T:E])->E? {
        return underscore.sample(underscore.values(dictionary))
    }
    
    class func sample<T:Hashable, E> (dictionary:[T:E], _ count:Int)->[E] {
        return underscore.sample(underscore.values(dictionary), count)
    }
    
    //array only
    class func initial<T> (var array:[T], var _ count:Int)->[T] {
        while count-- > 0 && array.count > 0 { array.removeLast() }
        return array
    }
    class func initial<T> (var array:[T])->[T] {
        return underscore.initial(array, 1)
    }
    
    class func rest<T> (var array:[T], var _ count:Int)->[T] {
        while count-- > 0 && array.count > 0 { array.removeAtIndex(0) }
        return array
    }
    class func rest<T> (var array:[T])->[T] {
        return underscore.rest(array, 1)
    }
    
    class func reverse<T> (array:[T])->[T] {
        var resultArray = [T]()
        underscore.each(array, { (item, index, stop) -> () in resultArray.insert(item, atIndex:0) })
        return resultArray
    }
    
    //array:Equatable only
    
    
    class func contains<T:Equatable> (array:[T], _ value:T)->Bool {
        return underscore.indexOf(array, value) > -1
    }
    
    class func union<T:Equatable> (arrays:[T]...) -> [T] {
        return underscore.union(arrays);
    }
    
    private class func union<T:Equatable> (arrays:[[T]]) -> [T] {
        var resultArray = [T]()
        for array in arrays { resultArray += array }
        return underscore.uniq(resultArray)
    }
    
    private class func intersectionTowArray<T:Equatable> (array:[T], otherArray:[T]) -> [T] {
        return underscore.filter(array, { (item, index) -> Bool in
            return underscore.contains(otherArray, item)
        })
    }
    
    class func intersection<T:Equatable> (arrays:[T]...) -> [T] {
        var resultArray = arrays[0]
        underscore.each(arrays, { (array, index, stop) -> () in
            resultArray = underscore.intersectionTowArray(resultArray, otherArray: array)
        })
        return resultArray
    }
    
    class func uniq<T:Equatable> (array:[T]) -> [T] {
        var resultArray = [T]()
        underscore.each(array, { (item, index, stop) -> () in
            if !underscore.contains(resultArray, item) { resultArray.append(item) }
        })
        return resultArray
    }
    class func indexOf<T:Equatable> (array:[T], _ value:T) -> Int {
        var index = -1
        underscore.each(array, { (item, _index, stop) -> () in
            if value == item {
                index = _index
                stop = true
            }
        })
        return index
    }
    class func lastIndexOf<T:Equatable> (array:[T], _ value:T) -> Int {
        return underscore.indexOf(underscore.reverse(array), value)
    }
    class func without<T:Equatable> (array:[T], _ withouts:[T])->[T] {
        return underscore.without(array, withouts)
    }
    class func without<T:Equatable> (array:[T], _ withouts:T...)->[T] {
        var resultArray = [T]()
        underscore.each(withouts, { (without, index, stop) -> () in
            underscore.each(array, { (item, index, stop) -> () in
                if item != without { resultArray.append(item) }
            })
        })
        return resultArray
    }
    
    class func last<T> (array:[T]) -> T? {
        return array.last
    }
    
    class func first<T> (array:[T]) -> T? {
        return array.first
    }
    
    class func second<T> (array:[T]) -> T? {
        return underscore.at(array, 1)
    }
    
    class func third<T> (array:[T]) -> T? {
        return underscore.at(array, 2)
    }
    
    class func at<T> (array:[T], _ index:Int) -> T? {
        if index < array.count { return array[index] }
        return nil
    }
    
    
    //dictionary only
    class func keys<T:Hashable, E>(dictionary:[T:E])->[T] {
        return Array(dictionary.keys)
    }
    
    class func values<T:Hashable, E>(dictionary:[T:E])->[E] {
        return Array(dictionary.values)
    }
    
    private class func mergeTwoDictionary<T:Hashable, E>(var dictionary:[T:E], otherDictionary:[T:E])->[T:E] {
        underscore.each(otherDictionary, { (value, key, stop) -> () in dictionary[key] = value })
        return dictionary
    }
    
    class func merge<T:Hashable, E>(dictionarys:[T:E]...)->[T:E] {
        var resultDictionary = dictionarys[0]
        underscore.each(dictionarys, { (dictionary, index, stop) -> () in
            resultDictionary = underscore.mergeTwoDictionary(resultDictionary, otherDictionary:dictionary)
        })
        return resultDictionary
    }
    
    
    //utils
    class func random(var from:Int, var _ to:Int)->Int {
        if to - from < 0 { swap(&from, &to) }
        return from + Int(arc4random_uniform(UInt32(to - from + 1)))
    }
    
    class func random(var to:UInt32)->Int {
        return Int(arc4random_uniform(to + 1))
    }
    class func range(from:Int, _ to:Int,var _ step:Int)->[Int] {
        step = underscore.max([step, 1])!
        var resultArray = [Int](), m = 1, time = (to - from)/step
        if time < 0 {
            m = -1
            time = abs(Int(time))
        }
        while time-- > 0 { resultArray.insert(from + time*step*m, atIndex: 0) }
        return resultArray
    }
    
    class func range(from:Int, _ to:Int)->[Int] {
        return underscore.range(from, to, 1)
    }
    
    class func range(to:Int)->[Int] {
        return underscore.range(0, to, 1)
    }
    
    class func times<E> (count:Int, _ iteratee:(Int)->E)->[E] {
        var resultArray:[E] = Array()
        underscore.each(underscore.range(count), { (item, index, stop) -> () in
            resultArray.append(iteratee(item))
        })
        return resultArray
    }
    
    class func times<E> (count:Int, _ iteratee:(Int)->()) {
        underscore.each(underscore.range(count), { (item, index, stop) -> () in
            iteratee(item)
        })
    }
    
    //chain
    private var resultArray: [AnyObject] = []
    private var chainQueue: [([AnyObject])->[AnyObject]] = []
    
    public init(_ array: [AnyObject]) {
        self.resultArray = array
    }
    
    private func chain(function: ([AnyObject]) -> [AnyObject]) -> underscore {
        self.chainQueue.append(function)
        return self
    }
    
    public func value ()->[AnyObject] {
        var result:[AnyObject] = self.resultArray
        
        for function in chainQueue {
            result = function(result)
        }
        return result
    }
    
    public func first()->AnyObject?  {
        return underscore.first(self.value())
    }
    
    public func second()->AnyObject? {
        return underscore.second(self.value())
    }
    
    public func third()->AnyObject? {
        return underscore.third(self.value())
    }
    
    public func last()->AnyObject? {
        return underscore.last(self.value())
    }
    
    public func at(index:Int)->AnyObject? {
        return underscore.at(self.value(), index)
    }
    
    public func find(iteratee:(item:AnyObject)->Bool)->AnyObject? {
        return underscore.find(self.value(), iteratee)
    }
    
    public func every(iteratee:(item:AnyObject)->Bool)->AnyObject? {
        return underscore.find(self.value(), iteratee)
    }
    
    public func some(iteratee:(item:AnyObject)->Bool)->AnyObject? {
        return underscore.some(self.value(), iteratee)
    }
    
    public func sample ()->AnyObject? {
        return underscore.sample(self.value())
    }
    
    public func each (iteratee:( item:AnyObject, index:Int, inout stop:Bool )->()) {
        underscore.each(self.resultArray, iteratee)
    }
    
    public func map (iteratee:( item:AnyObject, index:Int )->AnyObject)->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.map(result, { (item, index) -> AnyObject in
                return iteratee(item:item, index:index)
            })
        })
    }
    
    public func filter (iteratee:( item:AnyObject, index:Int )->Bool)->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.filter(result, { (item, index) -> Bool in
                return iteratee(item:item, index:index)
            })
        })
    }
    
    public func reject (iteratee:( item:AnyObject, index:Int )->Bool)->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.reject(result, { (item, index) -> Bool in
                return iteratee(item:item, index:index)
            })
        })
    }
    
    public func shuffle ()->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.shuffle(result)
        })
    }
    
    public func reverse ()->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.reverse(result)
        })
    }
    
    public func initial (count:Int)->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.initial(result, count)
        })
    }
    
    public func initial ()->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.initial(result)
        })
    }
    
    public func rest (count:Int)->underscore {
        return self.chain({ underscore.rest($0, count) })
    }
    
    public func rest ()->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.rest(result)
        })
    }
    
    public func sample (count:Int)->underscore {
        return self.chain({ (result) -> [AnyObject] in
            return underscore.sample(result, count)
        })
    }
}

typealias __ = underscore
