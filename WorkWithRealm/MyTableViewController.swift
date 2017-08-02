//
//  MyTableViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class MyTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    lazy var resipes: Results<Resipe> = {self.realm.objects(Resipe.self)}()
    lazy var users: Results<User> = {self.realm.objects(User.self)}()
    //    var resipes: Results<Resipe>!{
    //        didSet{
    //            resipes = realm.objects(Resipe.self)
    //        }
    //    }
    var chef: User!
    var selectedResipe = Resipe()
    let query = QueryToRealm()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        chef = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateDefaultResipes()
        if chef != nil{
            resipes = self.query.doQueryToRecipeInRealm().filter("creater.userName == %@", chef.userName)
            
        }else{
            resipes = self.query.doQueryToRecipeInRealm()
        }
        
        tableView.reloadData()
    }
    
    @IBAction func viewAllRecipes(_ sender: UIButton) {
        chef = nil
        resipes = self.query.doQueryToRecipeInRealm()
        tableView.reloadData()
    }
    
    func populateDefaultResipes() {
        
        if resipes.count == 0 { // if count equal 0, it means that cotegory doesn't have any record
            
            try! realm.write() { // adding records to database
                
                let defaultResipes = [["Chocolate Cake", "1", "1", "ChocolateCake.jpg", "Alex Gold"], ["Pizza", "1", "1", "pizza.jpeg","Nikky Rush"], ["Gamburger", "1", "1", "gamburger.jpg", "Nick Griffin"], ["Spagetti", "1", "1", "spagetti.jpeg", "Olivia Woll"], ["Sushi", "1", "1", "sushi.jpeg", "Pamela White"]] // creating default names of categories
                for resipe in defaultResipes { // creating new instance for each category, fill properties adn adding object to realm
                    let user = User()
                    let newResipe = Resipe()
                    newResipe.title = resipe[0]
                    newResipe.ingredience = resipe[1]
                    newResipe.steps = resipe[2]
                    let data = NSData(data: UIImageJPEGRepresentation(UIImage(named: resipe[3])!, 0.9)!)
                    let img = UIImage(data: data as Data)
                    newResipe.image = NSData(data: UIImagePNGRepresentation(img!)!) as Data
                    newResipe.date = Date()
                    user.userName = resipe[4]
                    newResipe.creater = user
                    self.realm.add(newResipe)
                    user.resipe.append(newResipe)
                    
                }
            }
            
            resipes = query.doQueryToRecipeInRealm()
        }
        
    }
    
    @IBAction func didSelectSort(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.resipes = self.resipes.sorted(byKeyPath: "date")
        }else{
            self.resipes = self.resipes.sorted(byKeyPath: "title")
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resipes.count
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
                let user = self.query.doQueryToRecipeInRealm()[indexPath.row].creater!.userName
                let recipeName = self.query.doQueryToRecipeInRealm()[indexPath.row].title
                self.realm.delete(self.resipes[indexPath.row])
                if self.query.doQueryToUserInRealm().filter("userName = '\(recipeName)'").first?.resipe.count == 0 {
                    self.realm.delete(self.query.doQueryToUserInRealm().filter("userName = '\(user)'"))
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC"{
            var ditailController = segue.destination as! DetailViewController
            ditailController.recipe = selectedResipe
        }
    }
    
    
}
