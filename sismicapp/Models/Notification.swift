//
//  Notification.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 26/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NotificationListItem{
    let id: String
    let type: String
    let content: String
    let status: Bool
    let time: String
    
    init?(json: JSON){
        guard let
            id = json["id"].string,
            type = json["type"].string,
            content = json["content"].string,
            status = json["status"].bool,
            time = json["time"].string
        else{
                return nil
        }
        
        self.id = id
        self.type = type
        self.content = content
        self.status = status
        self.time = time
    }
}

struct NotificationList {
    let list: [NotificationListItem]
    
    init?(json: JSON) {
        guard let seismsData = json["notifications"].array else {
            return nil
        }
        
        self.list = seismsData.flatMap(NotificationListItem.init)
    }
}

