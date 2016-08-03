//
//  Information.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 3/08/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Information{
    let id: String
    let title: String
    let content: String
    
    init?(json: JSON){
        
        guard let
            id = json["information"]["id"].string,
            title = json["information"]["title"].string,
            content = json["information"]["content"].string
            else{
                print(json)
                return nil
        }
        
        self.id = id
        self.title = title
        self.content = content
    }
}
