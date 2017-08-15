//
//  MyTableViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
import PromiseKit
import ObjectMapper
import Alamofire

class MyTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let query = QueryToRealm()
    var resipes: Results<Resipe>!
    var recipes: Results<Resipe>{
        get{
            if resipes == nil{
                resipes = self.query.doQueryToRecipeInRealm()
            }
            return resipes
        }
        set{
            self.resipes = newValue
        }
    }
    var users: Results<User>!
    var user: Results<User>{
        get{
            if users == nil{
                users = self.query.doQueryToUserInRealm()
            }
            return users
        }
        set{
            users = newValue
        }
    }
    var chef: User!
    var selectedResipe = Resipe()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        chef = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateDefaultResipes()
        if chef != nil{
            print(chef.userName)
//            recipes = self.query.doQueryToRecipeInRealm().filter("creater[FIRST].userName == %@", chef.userName)
          //  recipes = self.query.doQueryToRecipeInRealm().filter("creater.userName == %@", chef.userName)
            print(recipes)
        }else{
            recipes = self.query.doQueryToRecipeInRealm()
        }
        print(self.query.doQueryToUserInRealm())
        tableView.reloadData()
        let jsonFile = WorkWithJSON()
        jsonFile.getJSONFromServer()
        
    }
    
    @IBAction func viewAllRecipes(_ sender: UIButton) {
        chef = nil
        recipes = self.query.doQueryToRecipeInRealm()
        tableView.reloadData()
    }
    
    func populateDefaultResipes() {
        
        if recipes.count == 0 { // if count equal 0, it means that cotegory doesn't have any record

            let defaultResipes = [["Chocolate Cake", "1", "1", "ChocolateCake.jpg", "Alex Gold"], ["Pizza", "1", "1", "pizza.jpeg","Nikky Rush"], ["Gamburger", "1", "1", "gamburger.jpg", "Nick Griffin"], ["Spagetti", "1", "1", "spagetti.jpeg", "Olivia Woll"], ["Sushi", "1", "1", "sushi.jpeg", "Pamela White"]] // creating default names of categories
            var count = 0
            for resipe in defaultResipes { // creating new instance for each recipe, fill properties adn adding object to realm

                let newResipe = Resipe()
                newResipe.id = count
                newResipe.title = resipe[0]
                newResipe.ingredience = resipe[1]
                newResipe.steps = resipe[2]
                let data = NSData(data: UIImageJPEGRepresentation(UIImage(named: resipe[3])!, 0.9)!)
                let img = UIImage(data: data as Data)
                newResipe.image = NSData(data: UIImagePNGRepresentation(img!)!) as Data
                newResipe.date = Date()
                let user = User(name: resipe[4])
                
                try! self.realm.write {
                    self.realm.add(user)
                    let userInDB = self.query.doQueryToUserInRealm().filter("userName = '\(user.userName)'").first
                    userInDB?.resipe.append(newResipe)
                    userInDB?.countOfResipe = user.resipe.count
                }
                
                
//                addResipeToDatabase(newResipe: newResipe).then { savedRecipe in
//                    try! self.realm.write(){
//                        user.resipe.append(savedRecipe)
//                    }
//                    }.catch {error in
//                        print(error)
//                }
                count += 1
            }
            recipes = query.doQueryToRecipeInRealm()
            let currentUsers = query.doQueryToUserInRealm()
            let jsonFile = WorkWithJSON()
            jsonFile.saveToJSONFile(objects: currentUsers)
            jsonFile.saveToJSONFile(objects: recipes)
        }
        
    }
    
    func addResipeToDatabase(newResipe: Resipe) -> Promise<Resipe> {
        return Promise { fulfill, reject in
            try! realm.write(){
                self.realm.add(newResipe)
                fulfill(newResipe)
            }
        }
    }
    
    @IBAction func didSelectSort(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.recipes = self.recipes.sorted(byKeyPath: "date")
        }else{
            self.recipes = self.recipes.sorted(byKeyPath: "title")
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResipeCell", for: indexPath) as? ResipeTableViewCell {
            let resipe = resipes[indexPath.row]
            cell.configureCell(resipe: resipe)
            return cell
        }
        return ResipeTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedResipe = resipes[indexPath.row]
        
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedResipe = resipes[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write() {
                let userName = self.query.doQueryToRecipeInRealm()[indexPath.row].creater.first!.userName
                self.realm.delete(self.recipes[indexPath.row])
                let user = self.query.doQueryToRecipeInRealm()[indexPath.row].creater.first!
                user.countOfResipe = user.resipe.count
                if self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first?.resipe.count == 0 {
                    self.realm.delete(self.query.doQueryToUserInRealm().filter("userName = '\(userName)'"))
                    
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC"{
            let detailController = segue.destination as! DetailViewController
            detailController.recipe = selectedResipe
        }
    }
    
    
}
