//
//  SettingsViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 28/08/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift

final class SettingsViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private let settings: Observable<Settings>
    
    let magnitude: Observable<Double>
    let range: Observable<Double>
    let areNotificationsOn: Observable<Bool>
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.settings = self.sismicappService
            .load_settings(withDevice: token)
            .retry(3)
            .shareReplay(1)
        self.magnitude = self.settings.map{$0.magnitude}
        self.range = self.settings.map{$0.range}
        self.areNotificationsOn = self.settings.map{$0.areNotificationsOn}
    }
    
}