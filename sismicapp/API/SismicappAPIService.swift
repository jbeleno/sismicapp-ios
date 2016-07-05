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
    
    // ***************** HERE STARTS THE SERVICES ******************
    
    
    // ************************* <DEVICE> *****************************
    /*func registerDevice(withModel model: String, withOSVersion version: String) -> Observable<String> {
        
        let params: [String: AnyObject] = [
            "platform": "iOS",
            "version": version,
            "model": model,
            "app_version": Constants.version
        ]
        
        return request(.POST, ResourcePath.DeviceNew, parameters: params)
                    .rx_JSON()
                    .map(JSON.init)
                    .flatMap {
                        json -> Observable<String> in
                        guard let device_token = json["device_token"].string else {
                            return Observable.error
                        }
                        
                        return Observable.just(device_token)
                    }
    }
    
    func registerSession( withDevice device_token: String,
                            withLatitude latitude: String,
                          withLongitude longitude: String,
                                    withCity city: String,
                                withRegion region: String,
                              withCountry country: String) -> Observable<Bool> {
        
        let params: [String: AnyObject] = [
            "device_token": device_token,
            "latitude": latitude,
            "longitude": longitude,
            "city": city,
            "region": region,
            "country": country
        ]
        
        return request(.POST, ResourcePath.DeviceNew, parameters: params)
                .rx_JSON()
                .map(JSON.init)
                .flatMap {
                    json -> Observable<Bool> in
                    guard let status = true
                    where json["status"].string == "OK"
                    else {
                        return Observable.error
                    }
                
                    return Observable.just(status)
                }
    }
    
    func updateDevicePushKey( withDevice device_token: String,
                                  withPushKey pushKey: String) -> Observable<Bool> {
        
        let params: [String: AnyObject] = [
            "device_token": device_token,
            "pushKey": pushKey,
        ]
        
        return request(.POST, ResourcePath.DeviceNew, parameters: params)
                .rx_JSON()
                .map(JSON.init)
                .flatMap {
                    json -> Observable<Bool> in
                    guard let status = true
                    where json["status"].string == "OK"
                    else {
                        return Observable.error
                    }
                    
                    return Observable.just(status)
                }
    }*/
    
    // ************************ </DEVICE> *****************************
    
    // ----------------------------------------------------------------
    
    // ******************** <EMERGENCY SERVICE> ***********************
    
    
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
    
    
    
    // ******************* </EMERGENCY SERVICE> ***********************
}