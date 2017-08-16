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
        if recipe != nil{
            createrOfResipe.text = recipe.creater.first?.userName
            resipeTitle.text = recipe.title
            resipeIngredients.text = recipe.ingredience
            resipeSteps.text = recipe.steps
            //resipeImage.image = UIImage(data: recipe.image!)
            createRecipeBtn.setTitle("Save recipe", for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
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
                    createRecipe()
                    writeRecipeToJSON()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    editRecipe(recipe: recipe)
                    writeRecipeToJSON()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
            if title == "" || ingredients == "" || steps == "" || user == "" {
                createAlert(title: "Warning", massage: "Please fill all textFields!")
            }
        
    }
    func writeRecipeToJSON(){
        let recipes = query.doQueryToRecipeInRealm()
        let currentUsers = query.doQueryToUserInRealm()
        let jsonFile = WorkWithJSON()
        jsonFile.saveToJSONFile(objects: currentUsers)
        jsonFile.saveToJSONFile(objects: recipes)
    }
    func deleteRecipe(recipe: Resipe){
        let object = self.query.doQueryToRecipeInRealm().filter("id = \(recipe.id)")
        let userName = self.query.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!.creater.first!.userName
        let user = self.query.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!.creater.first!
        print(user)
        try! realm.write {
            self.realm.delete(object)
            user.countOfResipe = user.resipe.count
        }
        let json = WorkWithJSON()
        json.putJSONToServer(user: user)
        if self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first!.resipe.count == 0 {
            try! realm.write {
                self.realm.delete(self.query.doQueryToUserInRealm().filter("userName = '\(userName)'"))
            }
            json.deleteJSONFromServer(user: user)
        }
        
    }
    func editRecipe(recipe: Resipe){
        
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        var currentRecipe: Resipe? = self.query.doQueryToRecipeInRealm().filter("id = \(recipe.id)").first!
        
            if userName != recipe.creater.first!.userName{
                deleteRecipe(recipe: recipe)
                createRecipe()

            }else{
                try! realm.write {
                    currentRecipe?.title = title
                    currentRecipe?.ingredience = ingredients
                    currentRecipe?.steps = steps
                    currentRecipe?.setRecipeImage(resipeImage.image!)
                }
                let json = WorkWithJSON()
                let user = self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first!
                json.putJSONToServer(user: user)
            }
            
        
    }

    func createRecipe() {
        let newResipe = Resipe()
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let userName = createrOfResipe.text!
        var isUserInDB = self.query.doQueryToUserInRealm().filter("userName = '\(userName)'").first
        print(isUserInDB)
        try! realm.write(){
            newResipe.id = self.query.doQueryToRecipeInRealm().last!.id + 1
            newResipe.title = title
            newResipe.ingredience = ingredients
            newResipe.steps = steps
            newResipe.date = NSDate() as Date!
            newResipe.setRecipeImage(resipeImage.image!)
            let json = WorkWithJSON()
            if isUserInDB != nil {
                addRecipeToUser(newResipe: newResipe, isUserInDB: isUserInDB!).then{user in
                    json.putJSONToServer(user: user)
                    }
                
            }else{
                isUserInDB = User(name: userName)
                self.realm.add(isUserInDB!)
                let user = self.query.doQueryToUserInRealm().filter("userName = '\(isUserInDB!.userName)'").first
                
                
                addRecipeToUser(newResipe: newResipe, isUserInDB: user!).then{ user in
                    json.postJSONToServer(user: user)
                    }.then{_ in
                        print("User added to server DB")
                }

            }
        }
    }
    
    func addRecipeToUser(newResipe: Resipe, isUserInDB: User) -> Promise<User>{
        return Promise<User> { fulfill, reject in
            isUserInDB.resipe.append(newResipe)
            isUserInDB.countOfResipe = isUserInDB.resipe.count
            fulfill(isUserInDB)
        }
        
    }
    func createAlert(title: String, massage: String){
        let alert = UIAlertController(title: title, message: massage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        resipeImage.image = image!
        self.dismiss(animated: true, completion: nil)
    }
}







