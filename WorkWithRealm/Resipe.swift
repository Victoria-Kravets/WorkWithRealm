//
//  Category.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
class Resipe : Object {
    dynamic var title = ""
    dynamic var ingredience = ""
    dynamic var steps = ""
//    dynamic var image = Data()
//    func setRecipeImage(_ img: UIImage) {
//        let data = UIImagePNGRepresentation(img)
//        self.image = data!
//    }
//    func getRecipeImg() -> UIImage {
//        let img = UIImage(data: self.image as Data)!
//        return img
//    }
}
