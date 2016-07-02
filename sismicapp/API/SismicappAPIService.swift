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
    func registerDevice(withModel model: String, withOSVersion version: String) -> Observable<Device> {
        
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
                        json -> Observable<Device> in
                        guard let device = Device(json: json) else {
                            return Observable.error
                        }
                        
                        return Observable.just(device)
                    }
    }
    
    func updateDeviceLocation( withDevice device_token: integer,
                                 withLatitude latitude: String,
                               withLongitude longitude: String) -> Observable<DeviceLocation> {
        
        let params: [String: AnyObject] = [
            "device_token": device_token,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        return request(.POST, ResourcePath.DeviceNew, parameters: params)
            .rx_JSON()
            .map(JSON.init)
            .flatMap {
                json -> Observable<DeviceLocation> in
                guard let device_location = DeviceLocation(json: json) else {
                    return Observable.error
                }
                
                return Observable.just(device_location)
        }
    }
    
    func updateDevicePushKey( withDevice device_token: String,
                                  withPushKey pushKey: String) -> Observable<DeviceLocation> {
        
        let params: [String: AnyObject] = [
            "device_token": device_token,
            "pushKey": pushKey,
        ]
        
        return request(.POST, ResourcePath.DeviceNew, parameters: params)
            .rx_JSON()
            .map(JSON.init)
            .flatMap {
                json -> Observable<DeviceLocation> in
                guard let device_location = DeviceLocation(json: json) else {
                    return Observable.error
                }
                
                return Observable.just(device_location)
        }
    }
    
    // ************************ </DEVICE> *****************************
}