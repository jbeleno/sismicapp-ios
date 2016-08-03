//
//  InformationViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 3/08/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift

final class InformationViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private let information: Observable<Information>
    
    let id: Observable<String>
    let title: Observable<String>
    let content: Observable<String>
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService, information_id: String) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.information = self.sismicappService
            .details_information(withDevice: token, withInformationId: information_id)
            .retry(3)
            .shareReplay(1)
        
        self.id = self.information.map{$0.id}
        self.title = self.information.map{$0.title}
        self.content = self.information.map{$0.content}
    }
    
}
