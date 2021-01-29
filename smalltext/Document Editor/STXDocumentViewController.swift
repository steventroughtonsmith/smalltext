//
//  STXDocumentViewController.swift
//  smalltext
//
//  Created by Steven Troughton-Smith on 28/01/2021.
//

import UIKit

class STXDocumentViewController: UIViewController, UIColorPickerViewControllerDelegate, UIFontPickerViewControllerDelegate {
    
    var colorPickerViewController = UIColorPickerViewController()
    
    let textView = UITextView()
    
    let textSwatch = STXColorButton()
    let backgroundSwatch = STXColorButton()
    let fontButton = STXFontButton()
    
    enum STXColorPickerMemory {
        case text
        case background
    }
    
    var currentColorPicker = STXColorPickerMemory.text
    
    var font = UIFont.systemFont(ofSize: UIFloat(16)) {
        didSet {
            textView.font = font
            fontButton.documentFont = font
        }
    }
    
    public var document:STXDocument? {
        didSet {
            textView.text = document!.text()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        textView.frame = view.bounds
        textView.alwaysBounceVertical = true
        
        view.addSubview(textView)
        
        view.addSubview(textSwatch)
        view.addSubview(backgroundSwatch)
        view.addSubview(fontButton)
        
        textSwatch.glyph.image = UIImage(systemName: "textformat")
        backgroundSwatch.glyph.image = UIImage(systemName: "doc.text.fill")
        fontButton.label.text = "SF Display"
        
        backgroundSwatch.color = .white
        
        font = UIFont(name: "Monaco", size: UIFloat(16)) ?? UIFont.systemFont(ofSize: UIFloat(24))
        
        textSwatch.addTarget(self, action: #selector(pickTextColor(_:)), for: .touchUpInside)
        backgroundSwatch.addTarget(self, action: #selector(pickBackgroundColor(_:)), for: .touchUpInside)
        
        fontButton.addTarget(self, action: #selector(pickFont(_:)), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() {
        
        let swatchWidth = UIFloat(60)
        let swatchHeight = UIFloat(28)
        let padding = UIFloat(8)
        let topBarHeight = swatchHeight + padding * 2
        
        let safeRect = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.bounds.width-view.safeAreaInsets.left-view.safeAreaInsets.right, height: view.bounds.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom)
        let divisor = safeRect.divided(atDistance: topBarHeight, from: .minYEdge)
        
        
        textView.frame = divisor.remainder
        textView.setNeedsLayout()
        
        let topBarRect = divisor.slice
        
        textSwatch.frame = CGRect(x: padding, y: topBarRect.minY + padding, width: swatchWidth, height: swatchHeight)
        backgroundSwatch.frame = CGRect(x: topBarRect.maxX-padding-swatchWidth, y: topBarRect.minY + padding, width: swatchWidth, height: swatchHeight)
        
        fontButton.frame = CGRect(x: textSwatch.frame.maxX + padding, y: topBarRect.minY + padding, width: backgroundSwatch.frame.minX - padding - (textSwatch.frame.maxX + padding), height: swatchHeight)
    }
    
    // MARK: - Actions
    
    @objc func pickFont(_ sender:Any) {
        
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = true
        
        let vc = UIFontPickerViewController(configuration: config)
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = fontButton
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func pickTextColor(_ sender:Any) {
        colorPickerViewController = UIColorPickerViewController()
        
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = .popover
        colorPickerViewController.popoverPresentationController?.sourceView = textSwatch
        
        colorPickerViewController.selectedColor = textSwatch.color
        
        currentColorPicker = .text
        
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    @objc func pickBackgroundColor(_ sender:Any) {
        colorPickerViewController = UIColorPickerViewController()
        
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = .popover
        colorPickerViewController.popoverPresentationController?.sourceView = backgroundSwatch
        
        colorPickerViewController.selectedColor = backgroundSwatch.color
        
        currentColorPicker = .background
        
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    // MARK: - UIColorPickerViewControllerDelegate
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        if currentColorPicker == .text {
            textView.textColor = colorPickerViewController.selectedColor
            textSwatch.color = colorPickerViewController.selectedColor
        }
        else {
            textView.backgroundColor = colorPickerViewController.selectedColor
            backgroundSwatch.color = colorPickerViewController.selectedColor
        }
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if currentColorPicker == .text {
            textView.textColor = colorPickerViewController.selectedColor
            textSwatch.color = colorPickerViewController.selectedColor
        }
        else {
            textView.backgroundColor = colorPickerViewController.selectedColor
            backgroundSwatch.color = colorPickerViewController.selectedColor
        }
    }
    
    // MARK: - UIFontPickerViewControllerDelegate
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        
        if let descriptor = viewController.selectedFontDescriptor {
            let font = UIFont(descriptor: descriptor, size: descriptor.pointSize)
            fontButton.documentFont = font
            textView.font = font
        }
    }

}
