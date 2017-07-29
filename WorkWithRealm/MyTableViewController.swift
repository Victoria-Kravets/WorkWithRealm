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
    // creating instance Realm, fill categories througvarbjects(_:)
    //try will be throw error
    //lazy - property, default value didn't calculate before first use
    var selectedResipe = Resipe()
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        populateDefaultResipes()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func populateDefaultResipes() {
        print(resipes.count)
        if resipes.count == 0 { // if count equal 0, it means that cotegory doesn't have any record
            
            try! realm.write() { // adding records to database
                
                let defaultResipes = [["Chocolate Cake", "1", "1", "ChocolateCake.jpg"], ["Pizza", "1", "1", "pizza.jpeg"], ["Gamburger", "1", "1", "gamburger.jpg"], ["Spagetti", "1", "1", "spagetti.jpeg"], ["Sushi", "1", "1", "sushi.jpeg"]] // creating default names of categories
                
                for resipe in defaultResipes { // creating new instance for each category, fill properties adn adding object to realm
                    let newResipe = Resipe()
                    newResipe.title = resipe[0]
                    newResipe.ingredience = resipe[1]
                    newResipe.steps = resipe[2]
                    print(resipe[3])
                    let data = NSData(contentsOfFile: resipe[3])
                    if data != nil{
                        newResipe.image = data as! NSData
                    }
                    
                    newResipe.date = Date()
                    self.realm.add(newResipe)
                }
            }
            
            resipes = realm.objects(Resipe.self) // request all creating categories
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(resipes.count)
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        selectedResipe = resipes[indexPath.row]
        
        
        
//        let viewDetails = DetailViewController() //= self.storyboard?.instantiateViewController(withIdentifier: "View Detail") as! DetailViewController
//        viewDetails.a = "1"
//        viewDetails.b = "2"
//        viewDetails.c = "3"
//        self.present(viewDetails, animated: true, completion: nil)
//        viewDetails.fillUI(recipe: selectedResipe)
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
        }
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
    
 
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC"{
            var ditailController = segue.destination as! DetailViewController
            // your new view controller should have property that will store passed value
            ditailController.recipe = selectedResipe
        }
     }
 
    
}
