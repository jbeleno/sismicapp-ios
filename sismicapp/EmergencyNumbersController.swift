//
//  EmergencyNumbersController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit

class EmergencyNumbersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    // Declare static values for emergencies numbers
    let emergencyData: [Dictionary<String, String>] = [
        ["name": "Bomberos", "number": "119"],
        ["name": "Cruz Roja", "number": "132"],
        ["name": "Defensa Civil", "number": "144"],
        ["name": "Emergencias", "number": "123"],
        ["name": "Policía", "number": "112"]
    ]
    
    let cellIdentifier = "phoneCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup some thing from the table
        tableView.delegate = self
        tableView.dataSource = self
        
        // Row sizes in the tableView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 53.0
    }
    
    
    // Just one section in the table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    // The number of cells are the number of elements in the array defined above
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emergencyData.count
    }
    
    
    // Fill the table with the data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PhoneNumbersCell
        
        // Select the emergency data from the array location according the position in the table
        let data = emergencyData[indexPath.row]
        
        // Fill the cell with the data
        cell.name.text = data["name"]
        cell.number.text = data["number"]
        
        return cell
    }
    
    
    // If the user touch a cell start a call
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select the emergency data from the array location according the position in the table
        let data = emergencyData[indexPath.row]
        
        let url:NSURL? = NSURL(string: "tel://" + data["number"]!)
        UIApplication.sharedApplication().openURL(url!)
    }
}
