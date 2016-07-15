//
//  SeismController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 12/06/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import Mapbox
import RxSwift
import RxCocoa

//MARK: - SeismController
class SeismController: UIViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: SeismViewModel!
    private let disposeBag = DisposeBag()
    
    var seism_identifier: String = ""
    
    //MARK: - Outlets
    
    @IBOutlet weak var seism_map: MGLMapView!
    @IBOutlet weak var seism_title: UILabel!
    @IBOutlet weak var seism_text: UILabel!
    
    //MARK: - Lifecycle
    private func addBindsToViewModel(viewModel: SeismViewModel) {
        
        viewModel.title
            .bindTo(seism_title.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.text
            .bindTo(seism_text.rx_text)
            .addDisposableTo(disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //seism_map.delegate = self
        
        viewModel = SeismViewModel(sismicappService: SismicappAPIService(), seism_id: self.seism_identifier)
        addBindsToViewModel(viewModel)
    }
    
}
