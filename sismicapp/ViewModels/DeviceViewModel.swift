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
    let token: Observable<String>
    let device_location: Observable<DeviceLocation>
    
    var device: Observable<Device>{
        return device_location.map(self.createDevice)
    }
    
    
    let push_key: String
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
        self.token = sismicappService.registerDevice(withModel: self.model, withOSVersion: self.version).shareReplay(1)
        
        // Get the push key
        self.push_key = FIRInstanceID.instanceID().token()!
        
        // Request location from ip
        self.device_location = ipInfoService.getLocation()
        
        // Request location from GPS
        locationService = LocationService()
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    
    //MARK: - Private methods
    
    
    // This method observes when the device location changes and start the creation of
    // the device variable
    private func createDevice(from device_loc: DeviceLocation)-> Device {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let latitude = device_loc.latitude
        let longitude = device_loc.longitude
        let city = device_loc.city
        let region = device_loc.region
        let country = device_loc.country
        let device_token = defaults.stringForKey("deviceToken")
        
        print("Device Token: "+device_token!)
        print("Device Push Key: "+FIRInstanceID.instanceID().token()!)
        
        // Register a new session
        if((device_token) != nil){
            sismicappService.registerSession(withDevice: device_token!, withLatitude: latitude, withLongitude: longitude, withCity: city, withRegion: region, withCountry: country)
        }
        
        // Create a new device
        let dev = Device(token: device_token!, push_key: self.push_key, platform: self.platform, version: self.version, model: self.model, device_location: device_loc)
        
        return dev
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
