//
//  FeedbackViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 10/09/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

final class FeedbackViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let ipInfoService: IpInfoAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    var txt_feedback = Variable<String>("")
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, ipInfoService: IpInfoAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        self.ipInfoService = ipInfoService
        
        // let defaults = NSUserDefaults.standardUserDefaults()
        // let token = defaults.stringForKey("deviceToken") ?? ""
        

    }

    
    //MARK: - Public methods
    
    // Send feedback
    func sendFeedback(withMsg msg: String){
        
        print("SEND FEEDBACK")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        let device_location = ipInfoService.getLocation().retry(3)
        
        // # Machetazo ~ Gambiarra
        // The ViewModel always needs a bind/suscribe to execute cold observable
        device_location
            .observeOn(MainScheduler.instance)
            .subscribeNext{ dev_loc in
                let latitude = dev_loc.latitude
                let longitude = dev_loc.longitude
                let country = dev_loc.country
                let region = dev_loc.region
                let city = dev_loc.city
                
                
                self.sismicappService.send_feedback(withDevice: token, withMsg: msg, withLatitude: latitude, withLongitude: longitude, withCity: city, withRegion: region, withCountry: country)
            }
            .addDisposableTo(disposeBag)
    }
    
    
    
}