//
//  Seism.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 14/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON


struct SeismListItem{
    let id: String
    let magnitude: Double
    let epicenter: String
    let time: String
    
    init?(json: JSON){
        guard let
            id = json["id"].string,
            magnitude = json["magnitude"].double,
            epicenter = json["epicenter"].string,
            time = json["epicenter"].string
        else{
            return nil
        }
        
        self.id = id
        self.magnitude = magnitude
        self.epicenter = epicenter
        self.time = time
    }
}

struct SeismList {
    let list: [SeismListItem]
    
    init?(json: JSON) {
        guard let seismsData = json["posts"].array else {
                return nil
        }
        
        self.list = seismsData.flatMap(SeismListItem.init)
    }
}

