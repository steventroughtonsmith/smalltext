//
//  DocumentBrowserViewController.swift
//  smalltext
//
//  Created by Steven Troughton-Smith on 28/01/2021.
//

import UIKit
import SwiftUI

class STXDocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = nil
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .move)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let document = STXDocument(fileURL: documentURL)
        
        // Access the document
        document.open(completionHandler: { success in
            if success {
                
                let documentViewController = STXDocumentViewController()
                documentViewController.document = document
                
                #if targetEnvironment(macCatalyst)
                self.view.window?.windowScene?.titlebar?.representedURL = document.fileURL
                #endif
                self.view.window?.windowScene?.title = document.fileURL.lastPathComponent
                
                var animated = true
                
                #if targetEnvironment(macCatalyst)
                animated = false
                #endif
                
                documentViewController.modalPresentationStyle = .overFullScreen
                
                STXAppDelegate.appKitController?.perform(NSSelectorFromString("showWindowForSceneIdentifier:"), with: self.view.window?.windowScene?.session.persistentIdentifier)

                self.present(documentViewController, animated: animated, completion: nil)
            } else {
                STXAppDelegate.appKitController?.perform(NSSelectorFromString("hideWindowForSceneIdentifier:"), with: self.view.window?.windowScene?.session.persistentIdentifier)

            }
        })
    }
    
    func closeDocument(_ document: STXDocument) {
        dismiss(animated: true) {
            document.close(completionHandler: nil)
        }
    }
}

