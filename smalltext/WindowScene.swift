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
        
        let documentBrowserViewController = DocumentBrowserViewController()
        window?.rootViewController = documentBrowserViewController
        window?.makeKeyAndVisible()
        
        window?.backgroundColor = .white
        
        #if targetEnvironment(macCatalyst)
        window?.windowScene?.titlebar?.toolbar = NSToolbar()
        window?.windowScene?.titlebar?.toolbarStyle = .automatic
        window?.windowScene?.titlebar?.separatorStyle = .none
        #endif
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let inputURL = URLContexts.first?.url else { return }
        guard inputURL.isFileURL else { return }
                
        // Reveal / import the document at the URL
        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else { return }

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
