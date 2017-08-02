//
//  User.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/30/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
class User: Object {
    dynamic var userName = ""
    var count = 0
    var resipe = List<Resipe>()
    dynamic var countOfResipe : Int{
        count = resipe.count
        return count
    }
    convenience init(name: String){
        self.init()
        self.userName = name
    }
    
}
