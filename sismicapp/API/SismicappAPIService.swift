//
//  SismicappAPIService.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 2/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON
import Firebase
import FirebaseInstanceID
import FirebaseMessaging


class SismicappAPIService {
    
    // Here goes the constants that will be used on the Sismicapp
    // API Service
    private struct Constants {
        static let baseURL = "http://app.sismicapp.com/"
        static let version = "2.0"
    }
    
    // Here goes the URI's of services in the web
    enum ResourcePath: String {
        case DeviceNew = "device/add/"
        case DeviceLoadSettings = "device/load_settings/"
        case DeviceUpdatePushKey = "device/update_push_key/"
        case DeviceUpdateSettings = "device/update_settings/"
        case FeedbackNew = "feedback/add/"
        case ReportNew = "report/add/"
        case SeismList = "seism/all/"
        case SeismDetail = "seism/detail/"
        case SessionNew = "session/add/"
        
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    // Here goes the list of error that could handle the API
    enum APIError: ErrorType {
        case CannotParse
    }
    
    
    // [START device_services]
    
    // Register the device and return the device token assigned to identify it
    func registerDevice(        withModel model: String,
                          withOSVersion version: String) -> Observable<String> {
        
        print("START DEVICE REGISTER")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let token = defaults.stringForKey("deviceToken"){
            // Update the push key
            let push_key = FIRInstanceID.instanceID().token()!
            self.updateDevicePushKey(withDevice: token, withPushKey: push_key)
            
            return Observable.just(token)
        }else{
        
            let params: [String: AnyObject] = [
                "platform": "iOS",
                "version": version,
                "model": model,
                "app_version": Constants.version
            ]
        
            return request(.POST, ResourcePath.DeviceNew.path, parameters: params)
                        .rx_JSON()
                        .map(JSON.init)
                        .flatMap {
                            json -> Observable<String> in
                            print("DEVICE REGISTER RESPONSE: "+json.description)
                            guard let device_token = json["device_token"].string else {
                                return Observable.error(APIError.CannotParse)
                            }
                        
                            // Storing the data in NSUserDefaults
                            defaults.setObject(device_token, forKey: "deviceToken")
                            
                            // Update the push key
                            let push_key = FIRInstanceID.instanceID().token()!
                            self.updateDevicePushKey(withDevice: device_token, withPushKey: push_key)
                        
                            return Observable.just(device_token)
                        }
        }
    }
    
    // Update the push key generated by APNS in this device
    func updateDevicePushKey( withDevice device_token: String,
                                  withPushKey pushKey: String) -> Observable<Bool> {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.boolForKey("devicePushKeySent"){
            return Observable.just(true)
        }else{
        
            let params: [String: AnyObject] = [
                "device_token": device_token,
                "pushKey": pushKey,
            ]
        
            return request(.POST, ResourcePath.DeviceUpdatePushKey.path, parameters: params)
                    .rx_JSON()
                    .map(JSON.init)
                    .flatMap {
                        json -> Observable<Bool> in
                        guard let status: Bool = true
                            where json["status"].string == "OK"
                            else {
                                return Observable.just(false)
                        }
                        
                        if(status){
                            // Store the centinel variable
                            defaults.setObject(true, forKey: "devicePushKeySent")
                        }
                    
                        return Observable.just(status)
                    }
        }
    }
    
    // [END device_services]
    
    
    
    // [START emergency_services]
    
    // This method get an static array of EmergencyService objects
    func getEmergencyNumbers() -> [EmergencyService]{
        
        let emergencyServicesData: [EmergencyService] = [
            EmergencyService(json: JSON(["name": "Bomberos", "number": "119"]))!,
            EmergencyService(json: JSON(["name": "Cruz Roja", "number": "132"]))!,
            EmergencyService(json: JSON(["name": "Defensa Civil", "number": "144"]))!,
            EmergencyService(json: JSON(["name": "Emergencias", "number": "123"]))!,
            EmergencyService(json: JSON(["name": "Policía", "number": "112"]))!
        ]
        
        return emergencyServicesData
    }
    
    // [END emergency_services]
    
    
    
    // [START session_services]
    
    // Register a new session and update things like location and app version
    func registerSession( withDevice device_token: String,
                            withLatitude latitude: Double,
                          withLongitude longitude: Double,
                                    withCity city: String,
                                withRegion region: String,
                              withCountry country: String) -> Observable<Bool> {
        
        let params: [String: AnyObject] = [
            "device_token": device_token,
            "latitude": latitude,
            "longitude": longitude,
            "city": city,
            "region": region,
            "country": country,
            "app_version": Constants.version
        ]
        
        
        return request(.POST, ResourcePath.SessionNew.path, parameters: params)
            .rx_JSON()
            .map(JSON.init)
            .flatMap {
                json -> Observable<Bool> in
                guard let status: Bool = true
                    where json["status"].string == "OK"
                    else {
                        return Observable.error(APIError.CannotParse)
                }
                
                // Try to update the push key each time the session is updated
                let push_key = FIRInstanceID.instanceID().token()!
                self.updateDevicePushKey(withDevice: device_token, withPushKey: push_key)
                
                return Observable.just(status)
        }
    }
    
    // [END session_services]
}