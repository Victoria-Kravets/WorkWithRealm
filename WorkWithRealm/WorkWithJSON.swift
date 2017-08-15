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
import AlamofireObjectMapper

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
            if let value = response.result.value! as? Dictionary<String, Any>{
                
                if let users = value["users"] as? Array<Any>{
                    for element in users{
                        if let user = element as? Dictionary<String, Any>{
                            print(user)
                            if let userName = user["userName"] as? String{
                                print(userName)
                            }
                            if let countOfRecipes = user["countOfResipe"] as? Int{
                                print(countOfRecipes)
                            }
                            if let recipes = user["resipe"] as? Array<Any>{
                                for element in recipes{
                                    //print(recipe)
                                    if let recipe = element as? Dictionary<String, Any>{
                                        print(recipe)
                                        if let id = recipe["id"] as? Int{
                                            print(id)
                                        }
                                        if let title = recipe["title"] as? String{
                                            print(title)
                                        }
                                        if let ingredience = recipe["ingredience"] as? String{
                                            print(ingredience)
                                        }
                                        if let steps = recipe["steps"] as? String{
                                            print(steps)
                                        }
                                        print(recipe["date"])
                                        if let date = recipe["date"] as? Date{
                                            print(date)
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
           // print(value)
            
        }
//        let url = "http://localhost:3000/db"
//        Alamofire.request(url).responseObject{ (response: DataResponse<User>) in
//            let userResponse = response.result.value
//            print(response)
//            
//        }
    }
    func putJSONFromServer(){
        
    }
    func postJSONFromServer(){
        
    }
    

}
