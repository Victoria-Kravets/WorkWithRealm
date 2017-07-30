//
//  UserTableViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/30/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class UserTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var arrayOfChefs = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var count = 0
        let uses = realm.objects(User.self)
        for user in uses{
            
            if arrayOfChefs.count != 0{
                for chef in arrayOfChefs{
                    if chef.userName == user.userName{
                        arrayOfChefs.remove(at: arrayOfChefs.index(of: chef)!)
                        count -= 1
                    }
                }
                arrayOfChefs.append(user)
                count += 1
            }else{
                arrayOfChefs.append(user)
            }
        }
        print(arrayOfChefs)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfChefs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell{
            cell.userNameLbl.text = arrayOfChefs[indexPath.row].userName
            if arrayOfChefs[indexPath.row].countOfResipe == 1{
                cell.countOfResipe.text = String(arrayOfChefs[indexPath.row].countOfResipe) + " resipe"
            }else{
                cell.countOfResipe.text = String(arrayOfChefs[indexPath.row].countOfResipe) + " resipes"
            }
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
