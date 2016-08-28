//
//  Settings.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 28/08/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Settings{
    let magnitude: Double
    let range: Double
    let areNotificationsOn: Bool
    
    init?(json: JSON){
        
        guard let
            magnitude = json["settings"]["magnitude"].double,
            range = json["settings"]["range"].double,
            areNotificationsOn = json["settings"]["areNotificationsOn"].bool
            else{
                return nil
        }
        
        self.magnitude = magnitude
        self.range = range
        self.areNotificationsOn = areNotificationsOn
    }
}
