//
//  HomeController.swift
//  sismicapp
//
//  This file handles with receiving and show in the screen a set of post
//  (seism data, ads, etc)
//
//  Created by Juan Beleño Díaz on 10/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


//MARK: - HomeController
class HomeController: UIViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: SeismListViewModel!
    private let disposeBag = DisposeBag()
    
    private var seism_identifier = ""
    private let segue_identifier = "home_seism_segue"
    
    private var refresh_control = UIRefreshControl()
    private let refresh_control_text = "Desliza hacia abajo para refrescar..."
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: SeismListViewModel) {
        
        // This is a Gambiarra ~ Machetazo, however this is a
        // more elegant solution for this problem
        refresh_control.rx_controlEvent(.ValueChanged)
            .flatMapLatest{ is_refreshing -> Observable<DeviceLocation> in
                return viewModel.getLocation()
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext { location in
                
                // Parses the location and sends the feedback
                viewModel.reloadSeismList(withLatitude: location.latitude, withLongitude: location.longitude, withCity: location.city, withRegion: location.region, withCountry: location.country)
                
                // Change the refresh control status
                self.refresh_control.endRefreshing()
            }
            .addDisposableTo(disposeBag)
        
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
        
        // Setup the refresh action
        self.refresh_control.attributedTitle = NSAttributedString(string: refresh_control_text)
        self.tableView.addSubview(self.refresh_control)
        
        self.viewModel = SeismListViewModel(sismicappService: SismicappAPIService(), ipInfoService: IpInfoAPIService())
        addBindsToViewModel(viewModel)
    }
    
    
    //MARK: - TableViewData
    
    //The data to update the tableView with. There is a better way to update the
    //tableView with RxSwift, please see
    //https://github.com/ReactiveX/RxSwift/tree/master/RxExample
    //However this implementation is much simpler
    private var tableViewData: [SeismListItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
}


//MARK: - Table View Data Source & Delegate
extension HomeController: UITableViewDataSource, RxTableViewDataSourceType {
    
    //Gets called on tableView.rx_elements.bindTo methods
    func tableView(tableView: UITableView, observedEvent: Event<[SeismListItem]>) {
        
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
    
    // The number of rows in the tables are the seisms in the list
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.count ?? 0
    }
    
    // Fill the table with the seism list data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("seismCell", forIndexPath: indexPath) as! SeismCell
        
        guard let data = tableViewData?[indexPath.row] else {
            return cell
        }
        
        cell.magnitude.text = String(data.magnitude)
        cell.epicenter.text = data.epicenter
        cell.time.text = data.time
        cell.depth.text = data.depth
        
        return cell
    }
    
    // If the user touch a cell, then go to another view to see details
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select the seism list data from the array according the position in the table
        let data = tableViewData?[indexPath.row]
        self.seism_identifier = (data?.id)!
        
        self.performSegueWithIdentifier(segue_identifier, sender: self)
    }
    
    // The seism identifier is passed to the detail view before call it
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == segue_identifier){
            let view2load = segue.destinationViewController as! SeismController
            view2load.seism_identifier = self.seism_identifier
        }
    }
}

extension HomeController: UITableViewDelegate {}
