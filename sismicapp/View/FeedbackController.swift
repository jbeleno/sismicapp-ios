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

//MARK: - FeedbackController
class FeedbackController: UIViewController {
    
    //MARK: - Dependencies
    private var viewModel: FeedbackViewModel!
    private let disposeBag = DisposeBag()
    
    var is_available: Bool = true
    
    
    //MARK: - Outlets
    @IBOutlet weak var tv_feedback: UITextView!
    @IBOutlet weak var btn_save: UIBarButtonItem!
    
    
    //MARK: - Actions
    
    @IBAction func sendFeedback(sender: AnyObject) {
        
        print("Stage 0")
        
        // This is a hack and I'm  not proud about it :(
        if(self.is_available){
            self.is_available = false
            
            print("Stage 1")
            
            if( tv_feedback.text != "Escríbenos tus comentarios, quejas y recomendaciones..." &&
                tv_feedback.text != ""){
                
                print("Stage 2")
                
                viewModel.sendFeedback(withMsg: tv_feedback.text)
                
                // Set a 2 seconds delay to enable the button
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    self.is_available = true
                    self.tv_feedback.text = ""
                    print("Stage 3")
                }
            }
        }
    }

    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: FeedbackViewModel) {
        //btn_save.rx_tap
            //.map{ tv_feedback.rx_text }
            //.bindTo(viewModel.txt_feedback)
            //.addDisposableTo(disposeBag)
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

        
        
    }
    
}
