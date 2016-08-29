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
    let magnitude: Float
    let range: Float
    let areNotificationsOn: Bool
    
    init?(json: JSON){
        
        guard let
            magnitude = json["settings"]["magnitude"].float,
            range = json["settings"]["range"].float,
            areNotificationsOn = json["settings"]["areNotificationsOn"].bool
        else{
            return nil
        }
        
        self.magnitude = magnitude
        self.range = range
        self.areNotificationsOn = areNotificationsOn
    }
}
