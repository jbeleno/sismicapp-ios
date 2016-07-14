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
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: SeismListViewModel) {
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
        tableView.estimatedRowHeight = 53.0
        
        self.viewModel = SeismListViewModel(sismicappService: SismicappAPIService())
        addBindsToViewModel(viewModel)
    }
    
    
    //MARK: - TableViewData
    
    //The data to update the tableView with. These is a better way to update the
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
        
        return cell
    }
}

extension HomeController: UITableViewDelegate {}
