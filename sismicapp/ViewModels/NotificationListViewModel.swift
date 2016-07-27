//
//  NotificationListViewModel.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 26/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift

final class NotificationListViewModel {
    //MARK: - Dependecies
    
    private let sismicappService: SismicappAPIService
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Model
    
    private let notification_list: Observable<NotificationList>
    
    let cellData: Observable<[NotificationListItem]>
    
    
    //MARK: - Set up
    
    init(sismicappService: SismicappAPIService) {
        
        //Initialise dependencies
        
        self.sismicappService = sismicappService
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken") ?? ""
        
        self.notification_list = self.sismicappService
            .all_notifications(withDevice: token)
            .retry(3)
            .shareReplay(1)
        self.cellData = self.notification_list.map{$0.list}
        
    }
    
}