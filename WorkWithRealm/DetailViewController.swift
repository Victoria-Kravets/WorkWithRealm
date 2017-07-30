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

   
    @IBOutlet weak var createrLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    var realm = try! Realm()
    var recipe = Resipe()
 
    override func viewWillAppear(_ animated: Bool) {
        titleLbl.text = recipe.title
        createrLbl.text = recipe.creater?.userName
        ingredientsLbl.text = recipe.ingredience
        stepsLbl.text = recipe.steps
        imageView.image = UIImage(data: recipe.image as! Data)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    func fillUI(recipe: Resipe){
      //  print(recipe.title)
        self.recipe = recipe
        print(self.recipe)
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
