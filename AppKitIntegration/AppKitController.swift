//
//  AppKitController.swift
//  AppKitIntegration
//
//  Created by Steven Troughton-Smith on 30/01/2021.
//

import AppKit

extension NSObject {
    @objc func hostWindowForSceneIdentifier(_ identifier:String) -> NSWindow? {
        return nil
    }
}

class AppKitController : NSObject {
    @objc public func _marzipan_setupWindow(_ note:Notification) {
        
        NSLog("_marzipan_setupWindow: \(note.userInfo)")
        
        guard let userInfo = note.userInfo, let sceneIdentifier = userInfo["SceneIdentifier"] as? String else { return }
       
        hideWindowForSceneIdentifier(sceneIdentifier)
    }
    
    @objc public func hideWindowForSceneIdentifier(_ sceneIdentifier:String) {
        guard let appDelegate = NSApp.delegate as? NSObject else { return }
        
        if appDelegate.responds(to: #selector(hostWindowForSceneIdentifier(_:))) {
            guard let hostWindow = appDelegate.hostWindowForSceneIdentifier(sceneIdentifier) else { return }
            
            hostWindow.alphaValue = 0
        }
    }
    
    @objc public func showWindowForSceneIdentifier(_ sceneIdentifier:String) {
        guard let appDelegate = NSApp.delegate as? NSObject else { return }
        
        if appDelegate.responds(to: #selector(hostWindowForSceneIdentifier(_:))) {
            guard let hostWindow = appDelegate.hostWindowForSceneIdentifier(sceneIdentifier) else { return }
            
            hostWindow.alphaValue = 1
        }
    }
}
