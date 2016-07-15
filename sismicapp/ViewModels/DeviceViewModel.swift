//
//  DeviceViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 6/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import CoreLocation

final class DeviceViewModel {
    
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let ipInfoService: IpInfoAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    var token: Observable<String>
    var device_location: Observable<DeviceLocation>
    
    let platform: String
    let version: String
    let model: String
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, ipInfoService: IpInfoAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        self.ipInfoService = ipInfoService
        
        // Declare the static values for platform, version and model
        self.platform = "iOS"
        self.model = UIDevice.currentDevice().modelName
        self.version = UIDevice.currentDevice().systemVersion
        
        // Request for a device token
        self.token = sismicappService.registerDevice(withModel: self.model, withOSVersion: self.version).retry(3)
        
        // Request location from ip
        self.device_location = ipInfoService.getLocation().retry(3)
    }
    
    //MARK: - Public methods
    
    // Generate token
    func generateToken() -> Observable<String>{
        self.token = sismicappService.registerDevice(withModel: self.model, withOSVersion: self.version).retry(3)
        return self.token
    }
    
    // New session
    func newSession(withDevice device_token: String, withLatitude latitude: Double,
                    withLongitude longitude: Double, withCity city: String, withRegion region: String,
                        withCountry country: String){
        
        sismicappService.registerSession(withDevice: device_token, withLatitude: latitude,
                                         withLongitude: longitude, withCity: city, withRegion: region,
                                         withCountry: country)
        
    }
    
    // Update location based on IP
    
    func updateLocation() -> Observable<DeviceLocation>{
        self.device_location = ipInfoService.getLocation().retry(3)
        return self.device_location
    }
    
    // Update the push key
    func updatePushKey(withDeviceToken device_token: String, withPushKey pushKey: String) -> Observable<Bool>{
        return sismicappService.updateDevicePushKey(withDevice: device_token, withPushKey: pushKey).retry(3)
    }
    
}
