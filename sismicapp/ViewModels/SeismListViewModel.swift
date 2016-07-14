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
    
    // Data for a table in the format of Array(SeismListItem).
    // where each SeismListItem has id, epicenter, magnitude and time
    var cellData: Observable<[SeismListItem]> {
        return seism_list.map(self.cells)
    }
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken")
        
        self.seism_list = self.sismicappService.all_seisms(withDevice: token!)
    }
    
    
    
    //MARK: - Private methods
    
    ///Parses the seism list data into an array of seism list items.
    private func cells(from seismList: SeismList)-> [SeismListItem] {
        return seismList.list
    }

}