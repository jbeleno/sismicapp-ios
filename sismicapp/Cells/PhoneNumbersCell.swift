//
//  PhoneNumbersCell.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 14/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit

class PhoneNumbersCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        // Configure the cell for selected state
        // If there is nothing here not special transition
    }
}
