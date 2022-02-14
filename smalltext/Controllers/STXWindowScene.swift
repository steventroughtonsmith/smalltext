//
//  WindowScene.swift
//  issues
//
//  Created by Steven Troughton-Smith on 20/09/2020.
//

import UIKit

class STXWindowScene : NSObject, UISceneDelegate, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow(windowScene: scene as! UIWindowScene)
        
        NSLog("id = \(session.persistentIdentifier)")
        
        if let window = window {
            let documentBrowserViewController = STXDocumentBrowserViewController()
            window.rootViewController = documentBrowserViewController
            window.makeKeyAndVisible()
                        
            #if targetEnvironment(macCatalyst)
			window.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: UIFloat(320), height: UIFloat(320))
            #endif
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let inputURL = URLContexts.first?.url else { return }
        guard inputURL.isFileURL else { return }
        
        // Reveal / import the document at the URL
        guard let documentBrowserViewController = window?.rootViewController as? STXDocumentBrowserViewController else { return }
        
        documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
            if let error = error {
                // Handle the error appropriately
                print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
                return
            }
            
            // Present the Document View Controller for the revealed URL
            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
        }
    }
}
