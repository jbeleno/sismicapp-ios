//
//  ReportViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 17/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

final class ReportViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let ipInfoService: IpInfoAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    var response_text: Observable<String>
    
    // Setting up the click stream
    var is_reporting = Variable<Bool>(false)
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, ipInfoService: IpInfoAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        self.ipInfoService = ipInfoService
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        // Request location from ip when the user give click on the button
        let device_location = is_reporting.asObservable()
                                // it waits 2 seconds among clicks
                                .throttle(2, scheduler: MainScheduler.instance)
                                .flatMapLatest { flag -> Observable<DeviceLocation> in
            
                                    guard flag else {
                                        //flatMapLatest will flatten empty Observables
                                        //much like regular flatMap will flatten nil values
                                        return Observable.empty()
                                    }
            
                                    return ipInfoService.getLocation()
                                }
                                //make sure all subscribers use the same exact subscription
                                .shareReplay(1)
        
        // Send the seism report
        self.response_text = device_location
                                .observeOn(MainScheduler.instance)
                                .map{ dev_loc in
                                    let latitude = dev_loc.latitude
                                    let longitude = dev_loc.longitude
                                    let country = dev_loc.country
                                    let region = dev_loc.region
                                    let city = dev_loc.city
                                    
                                    // Gambiarra ~ Machetazo
                                    sismicappService.report_seism(withDevice: token, withLatitude: latitude,
                                                                         withLongitude: longitude, withCity: city,
                                                                         withRegion: region, withCountry: country)
                                    
                                    return "¡Gracias por reportar!"
                                }
        
    }
    
}