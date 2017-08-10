//
//  CreatingResipeViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
import AssetsLibrary.ALAssetsLibrary
import PromiseKit

class CreatingResipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    let query = QueryToRealm()
    var recipe: Resipe!
    
    @IBOutlet weak var createRecipeBtn: UIButton!
    @IBOutlet weak var createrOfResipe: UITextField!
    @IBOutlet weak var resipeTitle: UITextField!
    @IBOutlet weak var resipeIngredients: UITextField!
    @IBOutlet weak var resipeSteps: UITextField!
    @IBOutlet weak var resipeImage: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if recipe != nil{
//            createrOfResipe.text = recipe.creater.userName //!!
            resipeTitle.text = recipe.title
            resipeIngredients.text = recipe.ingredience
            resipeSteps.text = recipe.steps
            resipeImage.image = UIImage(data: recipe.image!)
            createRecipeBtn.setTitle("Save recipe", for: .normal)
        }
    }
    func configurePicker(){
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func createResipeButtonPressed(_ sender: UIButton) {
        
            let title = resipeTitle.text!
            let ingredients = resipeIngredients.text!
            let steps = resipeSteps.text!
            let user = createrOfResipe.text!
            
            if title != "" && ingredients != "" && steps != "" && user != "" {
                if recipe == nil{
                   let newRecipe = Resipe()
                    createRecipe(newResipe: newRecipe)
                }else{
                    deleteRecipe(recipe: recipe)
                }
                self.navigationController?.popViewController(animated: true)
            }
            
            if title == "" || ingredients == "" || steps == "" || user == "" {
                createAlert(title: "Warning", massage: "Please fill all textFields!")
            }
            
        
    }
    func deleteRecipe(recipe: Resipe){
        let object = self.query.doQueryToRecipeInRealm().filter("title = '\(recipe.title)'")
        try! realm.write {
            realm.delete(object)
        }
    }
//    func editRecipe(recipe: Resipe){
//        let title = resipeTitle.text!
//        let ingredients = resipeIngredients.text!
//        let steps = resipeSteps.text!
//        let userName = createrOfResipe.text!
//        let editRecipe = Resipe()
//        
//        let currentRecipe = self.query.doQueryToRecipeInRealm().filter("title = '\(recipe.title)'").first!
//        try! realm.write {
//            currentRecipe.creater?.userName = userName
//            currentRecipe.title = title
//            currentRecipe.ingredience = ingredients
//            currentRecipe.steps = steps
//            currentRecipe.setRecipeImage(resipeImage.image!)
//
//        }
//    }

    func createRecipe(newResipe: Resipe) {
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        var isUserInDB = self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first
        
        try! realm.write(){
            print(Int(self.query.doQueryToRecipeInRealm().last!.id)! + 1)
            newResipe.id = String(Int(self.query.doQueryToRecipeInRealm().last!.id)! + 1)
            newResipe.title = title
            newResipe.ingredience = ingredients
            newResipe.steps = steps
            newResipe.date = NSDate() as Date!
            newResipe.setRecipeImage(resipeImage.image!)
            if isUserInDB != nil {
                isUserInDB?.resipe.append(newResipe) //!!
            }else{
                isUserInDB = User(name: userName)
                self.realm.add(isUserInDB!)
                let user = self.query.doQueryToUserInRealm().filter("userName = '\(isUserInDB!.userName)'").first
                user?.resipe.append(newResipe)

                

            }
            
//            addResipeToDatabase(newResipe: newResipe).then{ recipe in
//                self.addRecipeToUser(newResipe: recipe, isUserInDB: isUserInDB!)
//                }.catch {error in
//                    print(error)
//            }
            
        }
       
    }
    func addResipeToDatabase(newResipe: Resipe) -> Promise<Resipe> {
        return Promise { fulfill, reject in
            self.realm.add(newResipe)
            fulfill(newResipe)
        }
    }
    
    func addRecipeToUser(newResipe: Resipe, isUserInDB: User){
        try!realm.write {
            isUserInDB.resipe.append(newResipe)
        }
    }
    func createAlert(title: String, massage: String){
        let alert = UIAlertController(title: title, message: massage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        resipeImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
