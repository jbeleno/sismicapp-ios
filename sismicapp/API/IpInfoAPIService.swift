//
//  IpInfoAPIService.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 6/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

class IpInfoAPIService {
    
    // Here goes the constants that will be used on the IP Info
    // API Service
    private struct Constants {
        static let baseURL = "http://ipinfo.io/"
    }
    
    // Here goes the list of error that could handle the API
    enum APIError: ErrorType {
        case CannotParse
    }
    
    // Get the device location information based on user IP
    func getLocation() -> Observable<DeviceLocation> {
        print("ENTRA")
        return request(.POST, Constants.baseURL, parameters: nil)
            .rx_JSON()
            .map(JSON.init)
            .flatMap {
                json -> Observable<DeviceLocation> in
                print("SALE")
                guard let device_location = DeviceLocation(json: json) else {
                    return Observable.error(APIError.CannotParse)
                }
                
                return Observable.just(device_location)
        }
    }
    
}
