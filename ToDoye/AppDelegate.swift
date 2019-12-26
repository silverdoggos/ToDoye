//
//  AppDelegate.swift
//  ToDoye
//
//  Created by Артём Шишкин on 22.11.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        } catch{
            print("Error initialising new realm, \(error)")
        }
        return true
    }
    

}

