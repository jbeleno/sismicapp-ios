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

// Extension from MGLMapView to handle with location update
private extension MGLMapView {
    var rx_driveCoordinates: AnyObserver<CLLocationCoordinate2D> {
        return UIBindingObserver(UIElement: self) { map, location in
            // Updating the position of the map
            map.setCenterCoordinate(location, zoomLevel: 9, animated: true)
            
            // Adding a marker to show the seism epicenter
            let marker = MGLPointAnnotation()
            marker.coordinate = location
            map.addAnnotation(marker)
        }.asObserver()
    }
}

//MARK: - SeismController
class SeismController: UIViewController {
    
    //MARK: - Dependencies
    
    private var viewModel: SeismViewModel!
    private let disposeBag = DisposeBag()
    
    var seism_identifier: String = ""
    let seism_text2share = UILabel(frame: CGRectMake(0, 0, 1, 1)) // Gambiarra ~ Machetazo
    
    //MARK: - Outlets
    
    @IBOutlet weak var seism_map: MGLMapView!
    @IBOutlet weak var seism_title: UILabel!
    @IBOutlet weak var seism_text: UILabel!
    
    // MARK - Actions
    @IBAction func shareSeism(sender: AnyObject) {
        let text_to_share = seism_text2share.text
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [text_to_share!], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Lifecycle
    private func addBindsToViewModel(viewModel: SeismViewModel) {
        
        viewModel.title
            .bindTo(seism_title.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.text
            .bindTo(seism_text.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.text2share
            .bindTo(seism_text2share.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.location
            .bindTo(seism_map.rx_driveCoordinates)
            .addDisposableTo(disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SeismViewModel(sismicappService: SismicappAPIService(),
                                           seism_id: self.seism_identifier)
        addBindsToViewModel(viewModel)
    }
    
}
