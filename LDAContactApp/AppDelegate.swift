//
//  AppDelegate.swift
//  LDAContactApp
//
//  Created by Mac on 4/5/17.
//  Copyright © 2017 LeDucAnh. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
// Swift

import  UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        // Firebase Init
        FIRApp.configure()

    }
     func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        
        
       // if (notificationSettings.types != UIUserNotificationType) {
            
         //   NSLog(@"Did register user notificaiton settings");
            application.registerForRemoteNotifications()
           // [application registerForRemoteNotifications];
      //  }

    }
    
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
     {
        

      //  NSLog(@"Did register for remote notifications with device token");
        //[Core registerForRemoteNotificationsWithDeviceToken:deviceToken];
  
        
        
}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        QBSettings.setAccountKey("rRcKRsqcfC7VPy3sUdiJ")
        QBSettings.setApplicationID(59052)
        
        QBSettings.setAuthKey("UvODmXfYgzxA3BU")
        
        QBSettings.setAuthSecret("rxgc7NQkdLcSzAN")
        QBSettings.setLogLevel(.debug)
        QBSettings.enableXMPPLogging()
        QBRTCConfig.setStatsReportTimeInterval(1.0)
        SVProgressHUD.setDefaultMaskType(.clear)
        QBRTCClient.initializeRTC()
        Settings.instance()
        /*        QBSettings.setAccountKey("7yvNe17TnjNUqDoPwfqp")
         QBSettings.setApplicationID(40718)
         
         QBSettings.setAuthKey("AnB-JpA6r4y6RmS")
         
         QBSettings.setAuthSecret("3O7Sr5Pg4Qjexwn")
         QBSettings.setLogLevel(.debug)
         QBSettings.enableXMPPLogging()
         QBRTCConfig.setStatsReportTimeInterval(1.0)
         SVProgressHUD.setDefaultMaskType(.clear)
         QBRTCClient.initializeRTC()
         Settings.instance()
         
*/

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }   

    func application(application: UIApplication,
                     openURL url: NSURL,
                     sourceApplication: String?,   // OK
        annotation: AnyObject?) -> Bool

    {
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
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

