//
//  FeedbackController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

//MARK: - FeedbackController
class FeedbackController: UIViewController, UITextViewDelegate {
    
    //MARK: - Dependencies
    private var viewModel: FeedbackViewModel!
    private let disposeBag = DisposeBag()
    
    var is_available: Bool = true
    
    
    //MARK: - Outlets
    @IBOutlet weak var tv_feedback: UITextView!
    @IBOutlet weak var btn_save: UIBarButtonItem!
    @IBOutlet weak var lbl_thanks: UILabel!
    
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: FeedbackViewModel) {
        
        // This is a Gambiarra ~ Machetazo, however this is a 
        // more elegant solution for this problem
        btn_save.rx_tap
            .flatMapLatest{ tap -> Observable<DeviceLocation> in
                return viewModel.getLocation()
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext { location in
                
                // Parses the location and sends the feedback
                viewModel.sendFeedback(withMsg: self.tv_feedback.text, withLatitude: location.latitude, withLongitude: location.longitude, withCity: location.city, withRegion: location.region, withCountry: location.country)
                
                // Change the TextView and the Label
                self.tv_feedback.text = ""
                self.lbl_thanks.text = "¡Gracias por tus comentarios!"
            }
            .addDisposableTo(disposeBag)
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the view model
        viewModel = FeedbackViewModel(sismicappService: SismicappAPIService(), ipInfoService: IpInfoAPIService())
        addBindsToViewModel(viewModel)
        
        // On touch dismiss the keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Some design details
        self.tv_feedback.layer.cornerRadius = 2.0
        self.tv_feedback.layer.masksToBounds = true
        self.tv_feedback.layer.borderColor = UIColor.init(colorLiteralRed: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).CGColor
        self.tv_feedback.layer.borderWidth = 1.0

        // Setting the delegate 
        self.tv_feedback.delegate = self
        
    }
    
    // Simulating the placeholder behavior
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == "Escríbenos tus comentarios, quejas y recomendaciones..."){
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == ""){
            textView.text = "Escríbenos tus comentarios, quejas y recomendaciones..."
        }
    }
    
}
