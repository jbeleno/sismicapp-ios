//
//  InformationController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - InformationController
class InformationController: UIViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: InformationViewModel!
    private let disposeBag = DisposeBag()
    
    var information_identifier: String = ""
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
    
    
    
    
    //MARK: - Lifecycle
    private func addBindsToViewModel(viewModel: InformationViewModel) {
        
        viewModel.title
            .bindTo(lbl_title.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.content
            .bindTo(lbl_content.rx_text)
            .addDisposableTo(disposeBag)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = InformationViewModel(sismicappService: SismicappAPIService(),
                                          information_id : self.information_identifier)
        addBindsToViewModel(viewModel)
    }
}
