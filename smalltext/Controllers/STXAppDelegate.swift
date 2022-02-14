//
//  AppDelegate.swift
//  smalltext
//
//  Created by Steven Troughton-Smith on 28/01/2021.
//

import UIKit

extension NSObject {
    @objc public func _marzipan_setupWindow(_ sender:Any) {
        
    }
    
    @objc public func hideWindowForSceneIdentifier(_ sceneIdentifier:String) {
   
    }
    
    @objc public func showWindowForSceneIdentifier(_ sceneIdentifier:String) {
    
    }
}

@main
class STXAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    #if targetEnvironment(macCatalyst)
    
    static var appKitController:NSObject?
    
    class func loadAppKitIntegrationFramework() {
        
        if let frameworksPath = Bundle.main.privateFrameworksPath {
            let bundlePath = "\(frameworksPath)/AppKitIntegration.framework"
            do {
                try Bundle(path: bundlePath)?.loadAndReturnError()
                
                let bundle = Bundle(path: bundlePath)!
                NSLog("[APPKIT BUNDLE] Loaded Successfully")
                
                if let appKitControllerClass = bundle.classNamed("AppKitIntegration.AppKitController") as? NSObject.Type {
                    appKitController = appKitControllerClass.init()
                    
					if let appKitController = appKitController {
						NotificationCenter.default.addObserver(appKitController, selector: #selector(_marzipan_setupWindow(_:)), name: NSNotification.Name("UISBHSDidCreateWindowForSceneNotification"), object: nil)
					}
                }
            }
            catch {
                NSLog("[APPKIT BUNDLE] Error loading: \(error)")
            }
        }
    }
    #endif
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if targetEnvironment(macCatalyst)
        STXAppDelegate.loadAppKitIntegrationFramework()
        #endif
		
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Ensure the URL is a file URL
        guard inputURL.isFileURL else { return false }
        
        // Reveal / import the document at the URL
        guard let documentBrowserViewController = window?.rootViewController as? STXDocumentBrowserViewController else { return false }
        
        documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
            if let error = error {
                // Handle the error appropriately
                print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
                return
            }
            
            // Present the Document View Controller for the revealed URL
            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
        }
        
        return true
    }
    
}

