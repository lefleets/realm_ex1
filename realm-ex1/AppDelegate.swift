//
//  AppDelegate.swift
//  realm-ex1
//
//  Created by Eric Lightfoot on 2019-08-23.
//  Copyright © 2019 Eric Lightfoot. All rights reserved.
//

import UIKit
import RealmSwift // Moved from didLaunch method

class AircraftProfileData: Object { // Moved from didLaunch method
    @objc dynamic var id: String = ""
    @objc dynamic var _registration: String? = nil
    @objc dynamic var _type: String? = nil
    let _latitude = RealmOptional<Double>()
    let _longitude = RealmOptional<Double>()
    @objc dynamic var _beaconId: String? = nil
    @objc dynamic var _autoArm: Bool = false
    @objc dynamic var _isSelected: Bool = false
    let _isInRange = RealmOptional<Bool>()
    let _micAmplitudeDbThreshold = RealmOptional<Double>()
    let _micLowPassCutoff = RealmOptional<Double>()
    let _Vs = RealmOptional<Double>()
    let _Vso = RealmOptional<Double>()
    let _beaconMinor = RealmOptional<Int>()
    @objc dynamic var _deviceId: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class AirportList: Object { // Moved from didLaunch method
    let id = RealmOptional<Int>()
    @objc dynamic var ident: String? = nil
    @objc dynamic var type: String? = nil
    @objc dynamic var name: String? = nil
    let latitude_deg = RealmOptional<Double>()
    let longitude_deg = RealmOptional<Double>()
    let elevation_ft = RealmOptional<Int>()
    @objc dynamic var continent: String? = nil
    @objc dynamic var iso_country: String? = nil
    @objc dynamic var iso_region: String? = nil
    @objc dynamic var municipality: String? = nil
    @objc dynamic var scheduled_service: String? = nil
    @objc dynamic var gps_code: String? = nil
    @objc dynamic var iata_code: String? = nil
    @objc dynamic var local_code: String? = nil
    @objc dynamic var home_link: String? = nil
    @objc dynamic var wikipedia_link: String? = nil
    @objc dynamic var keywords: String? = nil
    let scheduled_service_bool = RealmOptional<Bool>()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        import XCPlayground
//        import PlaygroundSupport
//        import RealmSwift
        
//        PlaygroundPage.current.needsIndefiniteExecution = true
        
        
        // Define your models like regular Swift classes
        let authURL = URL(string: "https://flashup-beta-1.us1.cloud.realm.io")!
        let userRealmURL = URL(string: "realms://flashup-beta-1.us1.cloud.realm.io/~/realm")!
        let airportsURL = URL(string: "realms://flashup-beta-1.us1.cloud.realm.io/airport-list")!
        
//        class AircraftProfileData: Object {
//            @objc dynamic var id: String = ""
//            @objc dynamic var _registration: String? = nil
//            @objc dynamic var _type: String? = nil
//            let _latitude = RealmOptional<Double>()
//            let _longitude = RealmOptional<Double>()
//            @objc dynamic var _beaconId: String? = nil
//            @objc dynamic var _autoArm: Bool = false
//            @objc dynamic var _isSelected: Bool = false
//            let _isInRange = RealmOptional<Bool>()
//            let _micAmplitudeDbThreshold = RealmOptional<Double>()
//            let _micLowPassCutoff = RealmOptional<Double>()
//            let _Vs = RealmOptional<Double>()
//            let _Vso = RealmOptional<Double>()
//            let _beaconMinor = RealmOptional<Int>()
//            @objc dynamic var _deviceId: String? = nil
//
//            override static func primaryKey() -> String? {
//                return "id"
//            }
//        }
//
//        class AirportList: Object {
//            let id = RealmOptional<Int>()
//            @objc dynamic var ident: String? = nil
//            @objc dynamic var type: String? = nil
//            @objc dynamic var name: String? = nil
//            let latitude_deg = RealmOptional<Double>()
//            let longitude_deg = RealmOptional<Double>()
//            let elevation_ft = RealmOptional<Int>()
//            @objc dynamic var continent: String? = nil
//            @objc dynamic var iso_country: String? = nil
//            @objc dynamic var iso_region: String? = nil
//            @objc dynamic var municipality: String? = nil
//            @objc dynamic var scheduled_service: String? = nil
//            @objc dynamic var gps_code: String? = nil
//            @objc dynamic var iata_code: String? = nil
//            @objc dynamic var local_code: String? = nil
//            @objc dynamic var home_link: String? = nil
//            @objc dynamic var wikipedia_link: String? = nil
//            @objc dynamic var keywords: String? = nil
//            let scheduled_service_bool = RealmOptional<Bool>()
//        }
        
        
        let credentials = SyncCredentials.usernamePassword(username: "el", password: "el")
        
        SyncUser.logIn(with: credentials, server: authURL) {
            (user, err) in
            
            if err != nil { print(err?.localizedDescription ?? "") }
            
            guard let user = user else {
                print("User DNE")
                return
            }
            
            
            let userRealmConfig = user.configuration(realmURL: userRealmURL, fullSynchronization: true)
            
            do {
                let db = try Realm(configuration: userRealmConfig)
                if let aircraft = db.objects(AircraftProfileData.self).first {
                    print(aircraft._registration ?? "(empty)")
                } else {
                    print("no aircraft found")
                }
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
            
            let airportListConfig = user.configuration(realmURL: airportsURL, fullSynchronization: true)
            do {
                let db = try Realm(configuration: airportListConfig)
                let airport = db.objects(AirportList.self).filter("ident = %@", "00AK")
                print(airport)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
            
            print("Complete")
        }

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

