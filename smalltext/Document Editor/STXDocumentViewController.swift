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
	
	let toolbarView = STXVisualEffectView(blurStyle: .systemChromeMaterial)
	
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
		textView.insetsLayoutMarginsFromSafeArea = true
		textView.automaticallyAdjustsScrollIndicatorInsets = false
		
		view.addSubview(textView)
		
		let hairlineView = STXHairlineDividerView()
		hairlineView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		hairlineView.borderMask = .bottom
		
		toolbarView.contentView.addSubview(hairlineView)
		
		toolbarView.contentView.addSubview(textSwatch)
		toolbarView.contentView.addSubview(backgroundSwatch)
		toolbarView.contentView.addSubview(fontButton)
		
		textSwatch.glyph.image = UIImage(systemName: "textformat")
		backgroundSwatch.glyph.image = UIImage(systemName: "doc.text.fill")
		fontButton.label.text = "SF Display"
		
		backgroundSwatch.color = .white
		
		font = UIFont(name: "Monaco", size: UIFloat(16)) ?? UIFont.systemFont(ofSize: UIFloat(16))
		
		textSwatch.addTarget(self, action: #selector(pickTextColor(_:)), for: .touchUpInside)
		backgroundSwatch.addTarget(self, action: #selector(pickBackgroundColor(_:)), for: .touchUpInside)
		
		fontButton.addTarget(self, action: #selector(pickFont(_:)), for: .touchUpInside)
		
		view.addSubview(toolbarView)
	}
	
	// MARK: -
	
	override func viewDidLayoutSubviews() {
		
		let swatchWidth = UIFloat(60)
		let swatchHeight = UIFloat(28)
		let padding = UIFloat(8)
		let topBarHeight = swatchHeight + padding * 2
		
		let safeRect = view.bounds.inset(by: view.safeAreaInsets)
		let divisor = safeRect.divided(atDistance: topBarHeight, from: .minYEdge)
		
		
		let combinedSafeInset = UIEdgeInsets(top: view.safeAreaInsets.top + topBarHeight, left: view.safeAreaInsets.left, bottom: view.safeAreaInsets.bottom, right: view.safeAreaInsets.right)
		
		textView.contentInset = view.safeAreaInsets
		textView.scrollIndicatorInsets = combinedSafeInset
		textView.frame = view.bounds
		
		var topBarRect = divisor.slice
		
		topBarRect.origin.y = 0
		topBarRect.size.height += view.safeAreaInsets.top
		
		toolbarView.frame = topBarRect
		
		textSwatch.frame = CGRect(x: padding, y: view.safeAreaInsets.top + padding, width: swatchWidth, height: swatchHeight)
		backgroundSwatch.frame = CGRect(x: topBarRect.maxX-padding-swatchWidth, y: view.safeAreaInsets.top + padding, width: swatchWidth, height: swatchHeight)
		
		fontButton.frame = CGRect(x: textSwatch.frame.maxX + padding, y: view.safeAreaInsets.top + padding, width: backgroundSwatch.frame.minX - padding - (textSwatch.frame.maxX + padding), height: swatchHeight)
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
