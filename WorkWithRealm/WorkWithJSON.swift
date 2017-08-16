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
import PromiseKit

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
    func getJSONFromServer() -> Promise<String>{
        
        return Promise<String> { fulfill, reject in
            let url = "http://localhost:3000/users"
            Alamofire.request(url)
                .responseArray { (response: DataResponse<[User]>) in
                    switch response.result {
                    case .success(let users):
                        do {
                            let realm = try! Realm()
                            try realm.write {
                                for user in users {
                                    print(user)
                                    realm.add(user)
                                    print("Success")
                                    fulfill("Success")
                                }
                            }
                        } catch let error as NSError {
                            //TODO: Handle error
                        }
                    case .failure(let error): break
                        //TODO: Handle error
                    }
            }
        }
        
    }

    func putJSONToServer(user: User) -> Promise<String>{
        return Promise<String>{ fulfill, reject in
            let url = "http://localhost:3000/users/\(user.id)"
            print(url)
            let realm = try! Realm()
            try! realm.write{
                let jsonUser = user.toJSON()
                print(jsonUser)
                request(url, method: .put, parameters: jsonUser, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                    case .success(let value):
                        let jsonObject = responseJSON.result.value
                        print(jsonObject)
                        fulfill("Success")
                        
                    case .failure(let error):
                        print(error)
                    }
                }

            }
        }

        
    }
    func postJSONToServer(user: User) -> Promise<String>{
        return Promise<String>{ fulfill, reject in
            let url = "http://localhost:3000/users"
            let jsonUser = user.toJSON()
            print(jsonUser)
            request(url, method: .post, parameters: jsonUser, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { responseJSON in
                
                switch responseJSON.result {
                case .success(let value):
                    let jsonObject = responseJSON.result.value
                    fulfill("Success")
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
