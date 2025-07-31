//
//  AppDelegate.swift
//  PokemonCodeid
//
//  Created by Rifky Radityatama on 29/07/25.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        printRealmDebugInfo()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func printRealmDebugInfo() {
        let config = Realm.Configuration.defaultConfiguration
        print("📂 Realm path:", config.fileURL?.path ?? "Not found")

        do {
            let realm = try Realm()
            let users = realm.objects(UserModel.self)
            print("👥 Total users in Realm:", users.count)

            for user in users {
                print("   - \(user.username) | \(user.email) | \(user.password)")
            }
        } catch {
            print("❌ Failed to open Realm:", error)
        }
    }

}

