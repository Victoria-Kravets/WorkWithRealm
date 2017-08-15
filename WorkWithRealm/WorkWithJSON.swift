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

    func putJSONToServer(){
        
        
    }
//    func postJSONToServer(user: User){
//        let url = "http://localhost:3000/users"
//        let params: [String: Any] = [
//            "userName" : user.userName,
//            "countOfResipe" : user.countOfResipe,
//            "resipe" :  user.resipe.first
//        ]
//        let param =
//        request(url).responseJSON{ responseJSON in
//            switch responseJSON.result{
//            case .success(let value):
//                if let jsonObject = Mapper<User>().toJSON(user){
//                    let post = Post(json: jsonObject)
//                    print(post)
//                }
//                
//            }
//            
//        }
//    }
    
    
}
