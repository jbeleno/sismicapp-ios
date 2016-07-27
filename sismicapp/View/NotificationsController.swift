//
//  NotificationsController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - NotificationsController
class NotificationsController: UIViewController {
    //MARK: - Dependencies
    
    private var viewModel: NotificationListViewModel!
    private let disposeBag = DisposeBag()
    
    private var notification_identifier = ""
    private let segue_identifier_seism = "notifications_seism_segue"
    private let segue_identifier_information = "notifications_information_segue"
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: NotificationListViewModel) {
        viewModel.cellData
            .bindTo(tableView.rx_itemsWithDataSource(self))
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup some thing from the table
        tableView.delegate = self
        
        // Row sizes in the tableView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 52.0
        
        self.viewModel = NotificationListViewModel(sismicappService: SismicappAPIService())
        addBindsToViewModel(viewModel)
    }
    
    
    //MARK: - TableViewData
    
    //The data to update the tableView with. These is a better way to update the
    //tableView with RxSwift, please see
    //https://github.com/ReactiveX/RxSwift/tree/master/RxExample
    //However this implementation is much simpler
    private var tableViewData: [NotificationListItem]? {
        didSet {
            tableView.reloadData()
        }
    }

}


//MARK: - Table View Data Source & Delegate
extension NotificationsController: UITableViewDataSource, RxTableViewDataSourceType {
    
    //Gets called on tableView.rx_elements.bindTo methods
    func tableView(tableView: UITableView, observedEvent: Event<[NotificationListItem]>) {
        
        switch observedEvent {
        case .Next(let items):
            tableViewData = items
        case .Error(let error):
            print(error)
            presentError()
        case .Completed:
            tableViewData = nil
        }
    }
    
    // The number of rows in the tables are the notifications in the list
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.count ?? 0
    }
    
    // Fill the table with the notifications list data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! NotificationNormalCell
        
        guard let data = tableViewData?[indexPath.row] else {
            return cell
        }
        
        cell.content.text = data.content
        cell.time.text = data.time
        
        return cell
    }
    
    // If the user touch a cell, then go to another view to see details
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Select the notification list data from the array according the position in the table
        let data = tableViewData?[indexPath.row]
        self.notification_identifier = (data?.id)!
        let type = (data?.type)!
        
        // Depending on the type of notification it follows the flow to seism or information view
        if(type == "seism_detail"){
            self.performSegueWithIdentifier(segue_identifier_seism, sender: self)
        }else if(type == "information"){
            self.performSegueWithIdentifier(segue_identifier_information, sender: self)
        }
        
    }
    
    // The seism identifier is passed to the detail view before call it
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == segue_identifier_seism){
            let view2load = segue.destinationViewController as! SeismController
            view2load.seism_identifier = self.notification_identifier
        }else if(segue.identifier == segue_identifier_information){
            let view2load = segue.destinationViewController as! InformationController
            view2load.information_identifier = self.notification_identifier
        }

    }
}

extension NotificationsController: UITableViewDelegate {}

