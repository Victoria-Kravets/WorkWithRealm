//
//  QueryToRealm.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/2/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import  RealmSwift
class QueryToRealm{
    
    func doQueryToRealm<T>(objectsInBd: Results<T>) -> Results<T>{
        let realm = try! Realm()
        var objects = objectsInBd
        objects = realm.objects(T.self)
        return objects

    }
}

//let realm = try! Realm()
//
//var objects = objectsInBd
//objects = realm.objects(T.self)
//return objects
