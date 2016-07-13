//
//  AppDelegate.swift
//  sismicapp
//
//  This file is handling with changing the default color in the TabBar,
//  it's handling with client side of notifications
//
//  Created by Juan Beleño Díaz on 18/05/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import RxSwift
import RxCocoa
import RxAlamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Dependencies
    
    private var deviceViewModel: DeviceViewModel!
    private let disposeBag = DisposeBag()

    var window: UIWindow?


    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Changing the tabBar color when the items are selected
        UITabBar.appearance().tintColor = UIColor.init(colorLiteralRed: 244.0/255.0,
                                                       green: 67.0/255.0,
                                                       blue: 54.0/255.0,
                                                       alpha: 1.0)
        
        // Register for remote notifications >= iOS 8.0
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Initialize Firebase
        FIRApp.configure()
        
        // Add observer for InstanceID token refresh callback.
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.tokenRefreshNotification),
                                                         name: kFIRInstanceIDTokenRefreshNotification,
                                                         object: nil)
        
        // Testing device view model
        self.deviceViewModel = DeviceViewModel(sismicappService: SismicappAPIService(), ipInfoService: IpInfoAPIService())
        addBindToDeviceModel()
        
        return true
    }
    
    func addBindToDeviceModel(){
        // # Machetazo ~ Gambiarra
        // The ViewModel always needs a bind/suscribe to execute cold observable
        self.deviceViewModel
            .token
            .subscribe()
            .addDisposableTo(disposeBag)
    }

    // [START receive_message]
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        // print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        // print("%@", userInfo)
    }
    // [END receive_message]
    
    
    
    // [START refresh_token]
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()!
        print("InstanceID token: \(refreshedToken)")
        
        // Trying to update the device push key
        let defaults = NSUserDefaults.standardUserDefaults()
        if let token = defaults.stringForKey("deviceToken") {
            // # Machetazo ~ Gambiarra
            // The ViewModel always needs a bind/suscribe to execute cold observable
            self.deviceViewModel
                .updatePushKey(token, withPushKey: refreshedToken)
                .subscribe()
                .addDisposableTo(disposeBag)
            
            self.deviceViewModel
                .device_location
                .observeOn(MainScheduler.instance)
                .subscribeNext{ dev_loc in
                    print("ENTRA")
                    let latitude = dev_loc.latitude
                    let longitude = dev_loc.longitude
                    let country = dev_loc.country
                    let region = dev_loc.region
                    let city = dev_loc.region
                    
                    self.deviceViewModel.newSession(token, withLatitude: latitude, withLongitude: longitude, withCity: city, withRegion: region, withCountry: country)
                }
                .addDisposableTo(disposeBag)
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    
    
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                // print("Unable to connect with FCM. \(error)")
            } else {
                // print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        connectToFcm()
    }
    
    
    
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]

}

