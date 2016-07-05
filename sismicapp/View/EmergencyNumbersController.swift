//
//  EmergencyNumbersController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit


//MARK: - EmergencyServiceModel

// Represents a presentation layer model for a EmergencyService
// to be displayed in a UITableViewCell
struct EmergencyServiceModel {
    let name: String
    let number: String
    let numberURL: NSURL
}



//MARK: -
//MARK: - EmergencyNumbersController
class EmergencyNumbersController: UIViewController {
    //MARK: - Dependencies
    
    private var viewModel: EmergencyServicesViewModel!
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: EmergencyServicesViewModel) {
        tableViewData = viewModel.cellData
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup some thing from the table
        tableView.delegate = self
        
        // Row sizes in the tableView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 53.0
        
        // Put coal in the fire
        viewModel = EmergencyServicesViewModel(sismicappService: SismicappAPIService())
        addBindsToViewModel(viewModel)
    }
    
    
    //MARK: - TableViewData
    
    //The data to update the tableView with. These is a better way to update the
    //tableView with RxSwift, please see
    //https://github.com/ReactiveX/RxSwift/tree/master/RxExample
    //However this implementation is much simpler
    private var tableViewData: [EmergencyServiceModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
}



//MARK: - Table View Data Source & Delegate
extension EmergencyNumbersController: UITableViewDataSource {
    
    // Number of sections, in this case is 1
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // The size of the array of EmergencyServiceModel will define the number
    // of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.count ?? 0
    }
    
    // Fill the table with the data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("phoneCell", forIndexPath: indexPath) as! PhoneNumbersCell
        
        // Select the emergency data from the array location according the position in the table
        guard let data = tableViewData?[indexPath.row] else {
            return cell
        }
        
        // Fill the cell with the data
        cell.name.text = data.name
        cell.number.text = data.number
        return cell
    }
    
    // If the user touch a cell start a call
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select the emergency data from the array location according the position in the table
        let data = tableViewData?[indexPath.row]
        
        UIApplication.sharedApplication().openURL((data?.numberURL)!)
    }
}

extension EmergencyNumbersController: UITableViewDelegate {}
