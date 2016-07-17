//
//  RedButtonController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RedButtonController: UIViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: ReportViewModel!
    private let disposeBag = DisposeBag()
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var btn_report: UIButton!
    @IBOutlet weak var lbl_response: UILabel!
    
    
    //MARK: - Lifecycle
    
    private func addBindsToViewModel(viewModel: ReportViewModel) {
        btn_report.rx_tap
            .map{ _ in true }
            .bindTo(viewModel.is_reporting)
            .addDisposableTo(disposeBag)
        
        viewModel.response_text
            .bindTo(lbl_response.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReportViewModel(sismicappService: SismicappAPIService(), ipInfoService: IpInfoAPIService())
        addBindsToViewModel(viewModel)
    }
}
