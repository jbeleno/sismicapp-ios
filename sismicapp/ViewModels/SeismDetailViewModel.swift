//
//  SeismDetailViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 15/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift

final class SeismViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private let seism: Observable<Seism>
    
    let id: Observable<String>
    let latitude: Observable<Double>
    let longitude: Observable<Double>
    let title: Observable<String>
    let text: Observable<String>
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, seism_id: String) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.seism = self.sismicappService.details_seism(withDevice: token, withSeismId: seism_id).shareReplay(1)
        self.id = self.seism.map{$0.id}
        self.latitude = self.seism.map{$0.latitude}
        self.longitude = self.seism.map{$0.longitude}
        self.title = self.seism.map{$0.title}
        self.text = self.seism.map{$0.text}
    }
    
}