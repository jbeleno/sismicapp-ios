//
//  SeismDetailViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 15/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

final class SeismViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private let seism: Observable<Seism>
    
    let id: Observable<String>
    let title: Observable<String>
    let text: Observable<String>
    let text2share: Observable<String>
    let location: Observable<CLLocationCoordinate2D>
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, seism_id: String) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.seism = self.sismicappService
                         .details_seism(withDevice: token, withSeismId: seism_id)
                         .retry(3)
                         .shareReplay(1)
        self.id = self.seism.map{$0.id}
        self.title = self.seism.map{$0.title}
        self.text = self.seism.map{$0.text}
        self.text2share = self.seism.map{$0.text2share}
        self.location = self.seism.map{
            CLLocationCoordinate2DMake($0.latitude, $0.longitude)
        }
    }
    
}