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
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.title = a //recipe.title
//        ingredientsLbl.text = b //recipe.ingredience
//        stepsLbl.text = c //recipe.steps
    }
    func fillUI(recipe: Resipe){
//      //  print(recipe.title)
//        self.recipe = recipe
//        print(self.recipe)
////        let rec = realm.objects(Resipe)
////        let y = rec.filter(recipe.title)
////        print(y)
////        print(rec)
//        
//        
//        
//        
//        navigationController?.title = recipe.title
//        ingredientsLbl.text = recipe.ingredience
//        stepsLbl.text = recipe.steps
//        print(recipe)
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