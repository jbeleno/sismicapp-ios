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
    let version: String
    let model: String
    let device_location: DeviceLocation
    
    
    init(token: String, push_key: String, platform: String,
         version: String, model: String, device_location: DeviceLocation) {
        
        self.token = token
        self.push_key = push_key
        self.platform = platform
        self.version = version
        self.model = model
        self.device_location = device_location
    }
    
}

struct DeviceLocation {
    
    let latitude: Double
    let longitude: Double
    let city: String
    let region: String
    let country: String
    
    init?(json: JSON) {
        
        guard let
            loc = json["loc"].string,
            city = json["city"].string,
            region = json["region"].string,
            country = json["country"].string
        else {
            return nil
        }
        
        
        let locationArr = loc.componentsSeparatedByString(",")
        self.latitude = (Double(locationArr[0]) ?? nil)!
        self.longitude = (Double(locationArr[1]) ?? nil)!
        self.city = city
        self.region = region
        self.country = country

    }
    
}