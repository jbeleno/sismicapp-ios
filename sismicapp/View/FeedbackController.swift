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
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var tv_feedback: UITextView!

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On touch dismiss the keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Some design details
        self.tv_feedback.layer.cornerRadius = 2.0
        self.tv_feedback.layer.masksToBounds = true
        self.tv_feedback.layer.borderColor = UIColor.init(colorLiteralRed: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0).CGColor
        self.tv_feedback.layer.borderWidth = 1.0

        
        
    }
    
}
