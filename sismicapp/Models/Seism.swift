//
//  Seism.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 14/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Seism{
    let id: String
    let latitude: Double
    let longitude: Double
    let title: String
    let text: String
    
    init?(json: JSON){
        
        guard let
            id = json["seism"]["id"].string,
            latitude = json["seism"]["latitude"].double,
            longitude = json["seism"]["longitude"].double,
            title = json["seism"]["title"].string,
            text = json["seism"]["text"].string
        else{
            print(json)
            return nil
        }
        
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.text = text
    }
}

struct SeismListItem{
    let id: String
    let magnitude: Double
    let epicenter: String
    let time: String
    let depth: String
    
    init?(json: JSON){
        guard let
            id = json["id"].string,
            magnitude = json["magnitude"].double,
            epicenter = json["epicenter"].string,
            time = json["time"].string,
            depth = json["depth"].string
        else{
            return nil
        }
        
        self.id = id
        self.magnitude = magnitude
        self.epicenter = epicenter
        self.time = time
        self.depth = depth
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

