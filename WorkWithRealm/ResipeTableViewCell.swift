//
//  ResipeTableViewCell.swift
//  WorkWithRealm
//
//  Created by Viktoria on 7/28/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import UIKit

class ResipeTableViewCell: UITableViewCell {

    @IBOutlet weak var resipeImage: UIImageView!
    @IBOutlet weak var resipeTitle: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
   
    func configureCell(resipe: Resipe){
        resipeTitle.text = resipe.title
        dateLbl.text = String(describing: resipe.date)
        print(resipe.title)
        resipeImage.image = resipe.getRecipeImg()
    }

}
