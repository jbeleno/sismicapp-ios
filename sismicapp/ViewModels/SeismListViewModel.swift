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
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private let seism_list: Observable<SeismList>
    
    let cellData: Observable<[SeismListItem]>
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.seism_list = self.sismicappService.all_seisms(withDevice: token).shareReplay(1)
        self.cellData = self.seism_list.map{$0.list}
        
    }

}