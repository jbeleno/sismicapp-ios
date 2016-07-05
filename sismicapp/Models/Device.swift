//
//  Device.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 5/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Device {
    let token: String
    let push_key: String
    let platform: String
    let version: Float
    let model: String
    let latitude: Float
    let longitude: Float
    let city: String
    let region: String
    let country: String
    
    init(token: String, push_key: String, platform: String,
         version: Float, model: String, latitude: Float,
         longitude: Float, city: String, region: String, country: String) {
        
        self.token = token
        self.push_key = push_key
        self.platform = platform
        self.version = version
        self.model = model
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.region = region
        self.country = country
        
    }
}