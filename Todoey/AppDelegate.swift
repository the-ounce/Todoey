//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 26.07.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising Realm: \(error)")
        }
        
        return true
    }


}
