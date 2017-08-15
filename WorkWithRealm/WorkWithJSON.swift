//
//  WorkWithJSON.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/11/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Alamofire
class WorkWithJSON{
    
    func saveToJSONFile<T>(objects: Results<T>){
        let realm = try! Realm()
        var arrayOfUsers = [User]()
        var arrayOfRecipes = [Resipe]()
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if objects is Results<User>{
            let fileUrl = documentDirectoryUrl?.appendingPathComponent("ListOfUsers.json")
            print(fileUrl!)
            for user in 0...objects.count - 1{
                arrayOfUsers.append(objects[user] as! User)
            }
            try! realm.write {
                let jsonUser =  Mapper<User>().toJSONArray(arrayOfUsers)
                do{
                    let data = try! JSONSerialization.data(withJSONObject: jsonUser, options: [])
                    try! data.write(to: fileUrl!)
                } catch {
                    print(error)
                }
            }
        }else{
            let fileUrl = documentDirectoryUrl?.appendingPathComponent("ListOfRecipes.json")
            print(fileUrl!)
            
            for recipe in 0...objects.count - 1{
                arrayOfRecipes.append(objects[recipe] as! Resipe)
            }
            try! realm.write {
                let jsonRecipe =  Mapper<Resipe>().toJSONArray(arrayOfRecipes)
                do{
                    let data = try! JSONSerialization.data(withJSONObject: jsonRecipe, options: [])
                    try! data.write(to: fileUrl!)
                } catch {
                    print(error)
                }
            }
        }
    }
    func getJSONFromServer() {
        let url = "http://localhost:3000/db"
        Alamofire.request(url).responseJSON{ response in
            let result = response.result
            print(result)
            let value = result.value!
            print(value)
          
        }
        
    }
    func putJSONFromServer(){
        
    }
    func postJSONFromServer(){
        
    }
    

}
