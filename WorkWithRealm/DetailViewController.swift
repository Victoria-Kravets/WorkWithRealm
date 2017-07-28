//
//  DetailViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    var realm = try! Realm()
    var recipe = Resipe()
    var a = ""
    var b = ""
    var c = ""
    override func viewWillAppear(_ animated: Bool) {
        print(recipe)
        self.navigationController?.title = "gujgh"
        ingredientsLbl?.text = recipe.ingredience
        stepsLbl.text = recipe.steps
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.title = a //recipe.title
//        ingredientsLbl.text = b //recipe.ingredience
//        stepsLbl.text = c //recipe.steps
    }
    func fillUI(recipe: Resipe){
      //  print(recipe.title)
        self.recipe = recipe
        print(self.recipe)
//        try! realm.write {
//            self.navigationController?.title = recipe.title
//            self.ingredientsLbl.text = recipe.ingredience
//            self.stepsLbl.text = recipe.steps
//        }
        
        
        
        
        
        print(recipe)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
