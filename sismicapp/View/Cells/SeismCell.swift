//
//  SeismCell.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 13/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit

class SeismCell: UITableViewCell {
    
    @IBOutlet weak var magnitude: UILabel!
    @IBOutlet weak var epicenter: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var depth: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Rounding the magnitude layer to let a circle
        self.magnitude.layer.cornerRadius = 18
        self.magnitude.layer.masksToBounds = true
        
        // Setting a red border color in the magnitude label
        let redColor : UIColor = UIColor( red: 244.0/255.0, green: 67.0/255.0, blue:54.0/255.0, alpha: 1.0 )
        self.magnitude.layer.borderColor = redColor.CGColor
        self.magnitude.layer.borderWidth = 2.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        // Configure the cell for selected state
        // If there is nothing here not special transition
    }
}
