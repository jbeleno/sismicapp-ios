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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        // Configure the cell for selected state
        // If there is nothing here not special transition
    }
}
