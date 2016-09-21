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
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, ipInfoService: IpInfoAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        self.ipInfoService = ipInfoService
    }

    
    //MARK: - Public methods
    
    // Send feedback
    func sendFeedback(withMsg msg: String, withLatitude latitude: Double,
                      withLongitude longitude: Double,
                      withCity city: String, withRegion region: String,
                      withCountry country: String) -> Observable<Bool>{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
                
                
        return self.sismicappService.send_feedback(withDevice: token, withMsg: msg, withLatitude: latitude, withLongitude: longitude, withCity: city, withRegion: region, withCountry: country)
    }
    
    // Get location
    func getLocation() -> Observable<DeviceLocation>{
        return ipInfoService.getLocation()
    }
    
}
