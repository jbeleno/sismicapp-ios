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
    
    var cellData: Observable<[SeismListItem]>{
        return seism_list.map{return $0.list}
    }
    
    // Setting up the click stream
    var is_loading = Variable<Bool>(true)
    var hasStoped = Variable<Bool>(false)
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, ipInfoService: IpInfoAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        self.ipInfoService = ipInfoService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.seism_list = self.sismicappService
            .all_seisms(withDevice: token)
        
        
        let location = is_loading.asObservable()
                            .flatMapLatest{ reload -> Observable<DeviceLocation> in
                                self.hasStoped.value = true
                                return ipInfoService.getLocation()
                            }
                            .catchError{error in
                                self.hasStoped.value = false
                                return Observable.error(error)
                            }
                            .shareReplay(1)
        
        let sess_updated = location
                            .flatMapLatest{ loc -> Observable<Bool> in
                                let latitude = loc.latitude
                                let longitude = loc.longitude
                                let city = loc.city
                                let region = loc.region
                                let country = loc.country
                                
                                return sismicappService.registerSession(withDevice: token, withLatitude: latitude,
                                    withLongitude: longitude, withCity: city, withRegion: region,
                                    withCountry: country)
                            }
                            .catchError{error in
                                self.hasStoped.value = false
                                return Observable.error(error)
                            }
                            .shareReplay(1)
        
        
        self.seism_list = sess_updated
                            .flatMapLatest{session_updated -> Observable<SeismList> in
                                return self.sismicappService
                                           .all_seisms(withDevice: token)
                            }
                            .catchError{error in
                                self.hasStoped.value = false
                                return Observable.error(error)
                            }
                            .shareReplay(1)
        
    }

}
