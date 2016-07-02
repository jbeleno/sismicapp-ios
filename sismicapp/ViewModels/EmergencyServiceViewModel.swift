//
//  EmergencyServiceViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 1/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation

class EmergencyServiceViewModel {
    private var es_instance: EmergencyService
    
    var nameText: String {
        return es_instance.name
    }
    
    var numberText: String {
        return es_instance.number
    }
    
    var numberURL: NSURL? {
        return NSURL(string: es_instance.number)
    }
    
    init(es_instance: EmergencyService) {
        self.es_instance = es_instance
    }
}