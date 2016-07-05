//
//  EmergencyService.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 1/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct EmergencyService {
    let name: String
    let number: String
    
    init?(json: JSON) {
        guard let
            name = json["name"].string,
            number = json["number"].string
        else {
            return nil
        }
        
        self.name = name
        self.number = number
    }
}