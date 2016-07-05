//
//  EmergencyServiceViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 1/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit

final class EmergencyServicesViewModel {
    
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    
    
    //MARK: - Model
    
    private let emergencyServices: [EmergencyService]
    
    ///Data for a table in the format of array of Emergency Services
    var cellData: [EmergencyServiceModel]
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService) {
        
        //Initialise dependencies
        self.sismicappService = sismicappService
        
        
        // Suscribe emergency services data to this variable
        self.emergencyServices = sismicappService.getEmergencyNumbers()
        
        // Fill cellData
        self.cellData = []
        self.cellData = fillCellsData(from: emergencyServices)
        
    }
    
    
    //MARK: - Private methods
    
    ///Parses the emergency services data into an array of pretty 
    // straightforward emergency services
    private func fillCellsData(from emergency_services: [EmergencyService])-> [EmergencyServiceModel] {
        
        var emergencyServiceModels: [EmergencyServiceModel]
        
        emergencyServiceModels = []
        
        for es in emergency_services {
            emergencyServiceModels.append(convertInEmergencyServiceModel(from: es))
        }
        
        return emergencyServiceModels
        
    }
    
    private func convertInEmergencyServiceModel(from es: EmergencyService)-> EmergencyServiceModel {
        return EmergencyServiceModel(
            name: es.name,
            number: es.number,
            numberURL: NSURL(string: "tel://" + es.number)!
        )
    }
    
}