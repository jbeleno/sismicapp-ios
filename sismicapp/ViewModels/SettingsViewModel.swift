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
    
    let magnitude: Observable<Float>
    let range: Observable<Float>
    let magnitude_txt: Observable<String>
    let range_txt: Observable<String>
    let areNotificationsOn: Observable<Bool>
    
    // Setting up the stream for updating the settings
    
    //var isSettingsUpdated: Variable<Bool>()
    
    
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
        
        self.magnitude = self.settings.map{ $0.magnitude }
        self.range = self.settings.map{ $0.range }
        self.magnitude_txt = self.settings.map{NSString(format: "Magnitud: %.1f Mw", $0.magnitude) as String }
        self.range_txt = self.settings.map{NSString(format: "Rango: %.0fkm", $0.range) as String}
        self.areNotificationsOn = self.settings.map{$0.areNotificationsOn}
    }
    
    
    //MARK: - Public methods
    
    // Updating the settings
    func updateSettings(withMagnitude magnitude: Float,
                        withRange range: Float,
                        withAreNotificationsOn areNotificationsOn: Bool){
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        sismicappService.updateSettings(withDevice: token, withMagnitude: magnitude, withRange: range, withAreNotificationsOn: areNotificationsOn)
        
    }
}