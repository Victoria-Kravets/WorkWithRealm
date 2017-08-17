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
    
    var chef: String!
    var selectedResipe = Resipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillRealm()
    }
    func fillRealm(){
        try! self.realm.write {
            realm.deleteAll()
        }
        let jsonFile = JSONService()
        jsonFile.getJSONFromServer().then {_ in
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        chef = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // populateDefaultResipes()
        if chef != nil{
            recipes = self.query.doQueryToRecipeInRealm().filter("ANY creater.userName = '1'")
        }else{
            recipes = self.query.doQueryToRecipeInRealm()
        }
        tableView.reloadData()
    }
    
    @IBAction func viewAllRecipes(_ sender: UIButton) {
        chef = nil
        recipes = self.query.doQueryToRecipeInRealm()
        tableView.reloadData()
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
            
            let userName = self.query.doQueryToRecipeInRealm()[indexPath.row].creater.first!.userName
            let user = self.query.doQueryToRecipeInRealm()[indexPath.row].creater.first!
            try! realm.write() {
                self.realm.delete(self.recipes[indexPath.row])
                user.countOfResipe = user.resipe.count
            }
            let jsonConverter = JSONService()
            jsonConverter.putJSONToServer(user: user)
            if self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first?.resipe.count == 0 {
                jsonConverter.deleteJSONFromServer(user: user)
                try! realm.write() {
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
