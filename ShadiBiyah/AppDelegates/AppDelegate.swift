//
//  AppDelegate.swift
//  BrothersGas
//
//  Created by Muhammad Ahmed on 7/15/21.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import Firebase
import Messages
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var navigationController : UINavigationController?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
       showLogin()
//        showSignUp()
//        self.showHome()
//        self.showCategoryItemVC()
//        self.showSettingVC()
        self.showCategoryItemDetailsVC()
        setValueInUserDefaults()
        
        
        // MARK: NAV CONTROLLER SETUP
//        setupNavController()
        DropDown.startListeningToKeyboard()
        GMSServices.provideAPIKey("AIzaSyBuc0XsagCwtVi6NEusW2f018sbopC3uuI")
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }

//        *********************************  FIREBASE PUSH NOTIFICATION ****************************
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
      //  Messaging.messaging().delegate = self
//        FirebaseApp.configure()
//        *********************************  FIREBASE PUSH NOTIFICATION ****************************

        return true
    }
    

    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

//MARK:-  NOTIFICATION CENTER DELEGATE
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // ...

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound, .badge]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}

//MARK:- FIREBASE PUSH NOTIFICATION
//extension AppDelegate : MessagingDelegate{
//
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//      print("Firebase registration token: \(String(describing: fcmToken))")
//
//      let dataDict: [String: String] = ["token": fcmToken ?? ""]
//      NotificationCenter.default.post(
//        name: Notification.Name("FCMToken"),
//        object: nil,
//        userInfo: dataDict
//      )
//      print("FCMMmmmmm")
//      // TODO: If necessary send token to application server.
//      // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//
//
//}

// MARK: NAVIGATION SETUP
extension AppDelegate{
    
//    func setupNavController() {
//        let sB = navigation.getStoryBoardForController(identifier: LeftMenuViewController.identifier)?.storyboardObject
//        let sBSplash = navigation.getStoryBoardForController(identifier:  SplashViewController.identifier)?.storyboardObject
//        let leftMenuVC = sB?.instantiateViewController(withIdentifier: LeftMenuViewController.identifier)
//        let initialVC = (sBSplash!.instantiateViewController(withIdentifier: SplashViewController.identifier)) as? SplashViewController
//
//        let leftMenuViewController: LeftMenuViewController = leftMenuVC as! LeftMenuViewController
//
//        // Create content and menu controllersnavigation
//        navigationController = UINavigationController.init(rootViewController: initialVC!)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        navigationController?.setNeedsStatusBarAppearanceUpdate()
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.isHidden = true
//        SlideMenuOptions.hideStatusBar = false
//        SlideMenuOptions.contentViewScale = 1.0
//        SlideMenuOptions.leftViewWidth = sideMenuViewController?.view.frame.width  ?? 450.0 * 0.8
//        SlideMenuOptions.panFromBezel = false
//        // Create side menu controller
//        sideMenuViewController = SlideMenuController(mainViewController: navigationController!, leftMenuViewController: leftMenuViewController)
//
//       self.window?.rootViewController = sideMenuViewController
//        //self.window!.backgroundColor = UIColor.white
//        self.window?.makeKeyAndVisible()
//    }
    
//    func setupNavController() {
//
//
//        let storyBoard = UIStoryboard(name: Constants.MAIN, bundle:nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: SplashViewController.identifier) as! SplashViewController
//       self.window?.rootViewController = controller
//        //self.window!.backgroundColor = UIColor.white
//        self.window?.makeKeyAndVisible()
//    }
    
    // MARK: SET CHECKIN AND VEHICLE STOCK ACKNOWLEDGEMENT IN USERDEFAULTS:
        func setValueInUserDefaults(){
            
            let userDefaults = Constants.userDefaults
            if userDefaults.object(forKey:"ApplicationUniqueIdentifier" ) == nil {
                let deviceID  =  UIDevice.current.identifierForVendor!.uuidString
                Constants.DEVICE_ID = deviceID
                userDefaults.set(deviceID, forKey: "ApplicationUniqueIdentifier")
                userDefaults.synchronize()
            } else {
                let deviceID  =  UIDevice.current.identifierForVendor!.uuidString
                Constants.DEVICE_ID = deviceID
            }
            
            if userDefaults.object(forKey: "isCheckedIn") != nil{
                if  let isCheckedIn = userDefaults.object(forKey: "isCheckedIn") as? Bool{
                    Constants.isCheckedIn = isCheckedIn
                }
            }else{
                userDefaults.setValue(false, forKey: "isCheckedIn")
                Constants.isCheckedIn = false
                userDefaults.synchronize()
            }
            
            if userDefaults.object(forKey: "isAcknowledged") != nil{
                if  let isAcknowledged = userDefaults.object(forKey: "isAcknowledged") as? Bool{
                    Constants.isAcknowledged = isAcknowledged
                }
            }
        }
}

extension AppDelegate {

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app in background")
    


        if application.applicationState == .background {
            print("yay")
        }
    }
    
    func showLogin(){
        let controller = LoginVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func showCategoryItemDetailsVC(){
        let controller = CategoryItemDetailsVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    func showSignUp(){
        let controller = SignUpVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    func showVerification(){
        let controller = SignUpVerificationVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    func showHome(){
        let controller = HomeVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    func showCategoryItemVC(){
        let controller = CategoryItemVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    func showSettingVC(){
        let controller = SettingsVC()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}
