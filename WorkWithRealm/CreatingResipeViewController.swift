//
//  CreatingResipeViewController.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit
import RealmSwift
class CreatingResipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var createrOfResipe: UITextField!
    @IBOutlet weak var resipeTitle: UITextField!
    @IBOutlet weak var resipeIngredients: UITextField!
    @IBOutlet weak var resipeSteps: UITextField!
    @IBOutlet weak var resipeImage: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func createResipeButtonPressed(_ sender: UIButton) {
        let title = resipeTitle.text!
        let ingredients = resipeIngredients.text!
        let steps = resipeSteps.text!
        let user = createrOfResipe.text!
        if title != "" && ingredients != "" && steps != "" && user != "" {
            let newResipe = Resipe()
            var isUserInDB = realm.objects(User.self).filter("userName = '\(user)'").first
            try! realm.write(){
                print(isUserInDB)
                if isUserInDB != nil {
                    newResipe.creater = isUserInDB
                    isUserInDB?.countOfResipe += 1
                    
                }else{
                    isUserInDB = User(name: user)
                    newResipe.creater = isUserInDB
                }
                newResipe.title = title
                newResipe.ingredience = ingredients
                newResipe.steps = steps
                newResipe.date = NSDate() as Date!
                newResipe.setRecipeImage(resipeImage.image!)
                self.realm.add(newResipe)
                
            }
            try!realm.write {
                print(newResipe)
                if isUserInDB != nil{
                    isUserInDB?.resipe.append(newResipe)
                    print(isUserInDB)
                }
                
            }
            self.navigationController?.popViewController(animated: true)
        }
        if title == "" || ingredients == "" || steps == "" || user == "" {
            createAlert(title: "Warning", massage: "Please fill all textFields!")
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
