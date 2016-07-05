//
//  UIViewController+presentError.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 4/07/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    ///Presents a UIAlertController with a predefined error message
    func presentError() {
        let alertController = UIAlertController(title: Text.Dialogues.errorTitle, message: Text.Dialogues.errorMessage, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: Text.Dialogues.okayText, style: .Default, handler: nil)
        alertController.addAction(okayAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}