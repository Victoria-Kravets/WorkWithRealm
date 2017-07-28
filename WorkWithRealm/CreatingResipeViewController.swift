//
//  CreatingResipeViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class CreatingResipeViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var resipeTitle: UITextField!
    @IBOutlet weak var resipeIngredients: UITextField!
    @IBOutlet weak var resipeSteps: UITextField!
    @IBOutlet weak var resipeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addImage(_ sender: UIButton) {
    }
    @IBAction func createResipeButtonPressed(_ sender: UIButton) {
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        
        if title != "" && ingredients != "" && steps != "" {
            try! realm.write(){
                let newResipe = Resipe()
                newResipe.title = resipeTitle.text!
                newResipe.ingredience = resipeIngredients.text!
                newResipe.steps = resipeIngredients.text!
                self.realm.add(newResipe)
            }
            if realm.refresh(){
                print("true")
            }
            
            realm.autorefresh = true
            self.navigationController?.popViewController(animated: true)
        }
        if title == "" || ingredients == "" || steps == "" {
            createAlert(title: "Warning", massage: "Please fill all textFields!")
        }
    }
    func createAlert(title: String, massage: String){
        let alert = UIAlertController(title: title, message: massage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
