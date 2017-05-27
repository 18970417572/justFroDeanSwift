//
//  AppDelegate.swift
//  publicSwift
//
//  Created by dean on 2017/5/26.
//  Copyright © 2017年 陶宏兴. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //集成友盟
        MobClick.setLogEnabled(true)
        let obj = UMAnalyticsConfig.init()
        obj.appKey = "592794317f2c7457b3000731"
        obj.channelId = "Test"
        MobClick.start(withConfigure: obj)
        
        
        
        //集成极光
        let entity = JPUSHRegisterEntity.init()
        
        if #available(iOS 10.0, *){
            entity.types = Int(UNAuthorizationOptions.alert.rawValue |
                                UNAuthorizationOptions.sound.rawValue |
                                UNAuthorizationOptions.badge.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        }else if #available(iOS 8.0, *){
            let type = UIUserNotificationType.alert.rawValue |
                                UIUserNotificationType.badge.rawValue |
                                UIUserNotificationType.sound.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey:"83bc053d13764bf4004f70c7", channel: "test", apsForProduction: true, advertisingIdentifier: ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        //JPUSHService.setup(withOption: launchOptions , appKey: "83bc053d13764bf4004f70c7", channel: "Test", apsForProduction: true)
        //JPUSHService.setDebugMode()
        
        
        AMapServices.shared().apiKey = "63290924e4bba5c6e53c049e85361b90"
        AMapServices.shared().enableHTTPS = true
        
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

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError:%@",error.localizedDescription)
    }
    
    
}




extension AppDelegate: JPUSHRegisterDelegate{
    //MARK: JPUSHRegisterDelegate
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
       
        let useInfo  = response.notification.request.content.userInfo
        if  (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(useInfo)
        }
        completionHandler()
    }
    
    
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let useInfo  =  notification.request.content.userInfo;
        if  (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(useInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))
    }
}

