//
//  SettingsController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - SettingsController
class SettingsController: UIViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: SettingsViewModel!
    private let disposeBag = DisposeBag()
    
    private var segue_identifier = "feedback_segue"
    
    
    //MARK: - Outlets

    @IBOutlet weak var sw_notifications: UISwitch!
    @IBOutlet weak var slider_magnitude: UISlider!
    @IBOutlet weak var slider_range: UISlider!
    @IBOutlet weak var lbl_magnitude: UILabel!
    @IBOutlet weak var lbl_range: UILabel!
    @IBOutlet weak var view_feedback: UIView!

    
    //MARK: - Actions
    
    @IBAction func magnitudeChanged(sender: AnyObject) {
        self.lbl_magnitude.text = NSString(format: "Magnitud: %.1f Mw", self.slider_magnitude.value) as String
    }
    
    @IBAction func rangeChanged(sender: AnyObject) {
        self.lbl_range.text = NSString(format: "Rango: %.0fkm", self.slider_range.value) as String
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On touch go to feedback view
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SettingsController.goToFeedback(_:)))
        self.view_feedback.addGestureRecognizer(gesture)
    }
    
    
    // On touch use a segue to feedback view
    func goToFeedback(sender:UITapGestureRecognizer){
        self.performSegueWithIdentifier(segue_identifier, sender: self)
    }
}
