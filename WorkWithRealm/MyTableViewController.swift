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
    
    lazy var resipes: Results<Resipe> = {self.realm.objects(Resipe.self)}()
    // creating instance Realm, fill categories througvarbjects(_:)
    //try will be throw error
    //lazy - property, default value didn't calculate before first use
    var selectedResipe = Resipe()
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDefaultResipes()
        
        
    }
    
    func populateDefaultResipes() {
        print(resipes.count)
        if resipes.count == 0 { // if count equal 0, it means that cotegory doesn't have any record
            
            try! realm.write() { // adding records to database
                
                let defaultResipes = [["Chocolate Cake", "1", "1"], ["Pizza", "1", "1"], ["Gamburger", "1", "1"], ["Spagetti", "1", "1"], ["Sushi", "1", "1"]] // creating default names of categories
                
                for resipe in defaultResipes { // creating new instance for each category, fill properties adn adding object to realm
                    let newResipe = Resipe()
                    newResipe.title = resipe[0]
                    newResipe.ingredience = resipe[1]
                    newResipe.steps = resipe[2]
                    self.realm.add(newResipe)
                }
            }
            
            resipes = realm.objects(Resipe.self) // request all creating categories
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print(resipes.count)
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resipes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? ResipeTableViewCell {
            let resipe = resipes[indexPath.row]
            cell.configureCell(resipe: resipe)
            
            return cell
        }else{
            return ResipeTableViewCell()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResipe = resipes[indexPath.row]
        let viewDetails = DetailViewController() //= self.storyboard?.instantiateViewController(withIdentifier: "View Detail") as! DetailViewController
        viewDetails.fillUI(recipe: selectedResipe)
        //print(selectedResipe)
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedResipe = resipes[indexPath.row]
        print(resipes[indexPath.row].title)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write() {
                realm.delete(self.resipes[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }// else if editingStyle == .insert {
        //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
