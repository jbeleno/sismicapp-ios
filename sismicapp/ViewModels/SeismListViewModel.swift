//
//  SeismListViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 14/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift

final class SeismListViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let ipInfoService: IpInfoAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private var seism_list: Observable<SeismList>
    
    var cellData: Observable<[SeismListItem]>
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, ipInfoService: IpInfoAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        self.ipInfoService = ipInfoService
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.seism_list = self.sismicappService
                              .all_seisms(withDevice: token)
                              .retry(3)
                              .shareReplay(1)
        
        self.cellData = self.seism_list.map{return $0.list}
        
    }
    
    //MARK: - Public methods
    
    // Send feedback
    func reloadSeismList(        withLatitude latitude: Double,
                               withLongitude longitude: Double,
                                         withCity city: String,
                                     withRegion region: String,
                                   withCountry country: String)-> Observable<[SeismListItem]>{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        sismicappService.registerSession(withDevice: token, withLatitude: latitude,
                                         withLongitude: longitude, withCity: city, withRegion: region,
                                         withCountry: country)
        
        self.seism_list = self.sismicappService
                            .all_seisms(withDevice: token)
                            .retry(3)
        
        self.cellData = self.seism_list
                            .map{return $0.list}
        
        return self.cellData
    }
    
    // Get location
    func getLocation() -> Observable<DeviceLocation>{
        return ipInfoService.getLocation()
    }

}
