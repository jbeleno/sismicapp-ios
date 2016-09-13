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
        
        updateSettings()
    }
    
    @IBAction func rangeChanged(sender: AnyObject) {
        self.lbl_range.text = NSString(format: "Rango: %.0fkm", self.slider_range.value) as String
        
        updateSettings()
    }
    
    @IBAction func notificationsChanged(sender: AnyObject) {
        updateSettings()
    }
    
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: SettingsViewModel) {
        
        viewModel.magnitude_txt
            .bindTo(lbl_magnitude.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.range_txt
            .bindTo(lbl_range.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.magnitude
            .bindTo(slider_magnitude.rx_value)
            .addDisposableTo(disposeBag)
        
        viewModel.range
            .bindTo(slider_range.rx_value)
            .addDisposableTo(disposeBag)
        
        viewModel.areNotificationsOn
            .bindTo(sw_notifications.rx_value)
            .addDisposableTo(disposeBag)
        
    }
    
    private func updateSettings(){
        // # Machetazo ~ Gambiarra
        // This code updates too fast and with every change, which means
        // many request to my server
        self.viewModel
            .updateSettings(withMagnitude: self.slider_magnitude.value,
                            withRange: self.slider_range.value, withAreNotificationsOn: self.sw_notifications.on)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the view model
        viewModel = SettingsViewModel(sismicappService: SismicappAPIService())
        addBindsToViewModel(viewModel)
        
        // On touch go to feedback view
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SettingsController.goToFeedback(_:)))
        self.view_feedback.addGestureRecognizer(gesture)
    }
    
    
    // On touch use a segue to feedback view
    func goToFeedback(sender:UITapGestureRecognizer){
        self.performSegueWithIdentifier(segue_identifier, sender: self)
    }
}
