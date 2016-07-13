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
    private var locationService: LocationService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    var token: Observable<String>
    var device_location: Observable<DeviceLocation>
    let latitude: Observable<Double>
    let longitude: Observable<Double>
    let country: Observable<String>
    let region: Observable<String>
    let city: Observable<String>
    
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
        
        self.latitude = self.device_location.map{$0.latitude}
        self.longitude = self.device_location.map{$0.longitude}
        self.country = self.device_location.map{$0.country}
        self.region = self.device_location.map{$0.region}
        self.city = self.device_location.map{$0.city}
        
        // Request location from GPS
        locationService = LocationService()
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    //MARK: - Public methods
    
    // Generate token
    func generateToken() -> Observable<String>{
        self.token = sismicappService.registerDevice(withModel: self.model, withOSVersion: self.version).retry(3)
        return self.token
    }
    
    // New session
    func newSession(withDevice: String, withLatitude: Double, withLongitude: Double, withCity: String, withRegion: String, withCountry: String){
        sismicappService.registerSession(withDevice: withDevice, withLatitude: withLatitude, withLongitude: withLongitude, withCity: withCity, withRegion: withRegion, withCountry: withCountry)
    }
    
    // Update location based on IP
    func updateLocation() -> Observable<DeviceLocation>{
        self.device_location = ipInfoService.getLocation().retry(3)
        return self.device_location
    }
    
    // Update the push key
    func updatePushKey(withDeviceToken: String, withPushKey: String) -> Observable<Bool>{
        return sismicappService.updateDevicePushKey(withDevice: withDeviceToken, withPushKey: withPushKey).retry(3)
    }
    
}

// MARK: LocationServiceDelegate
extension DeviceViewModel: LocationServiceDelegate {
    
    func locationDidUpdate(service: LocationService, location: CLLocation) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        defaults.setDouble(latitude, forKey: "latitude")
        defaults.setDouble(longitude, forKey: "longitude")
        
    }
}
