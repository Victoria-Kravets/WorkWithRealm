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
    dynamic var name = ""
    dynamic var countOfResipe = 0
    var resipe = List<Resipe>()
    
}
