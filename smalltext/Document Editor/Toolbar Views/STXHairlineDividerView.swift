//
//  PSTLHairlineDividerView.swift
//  Pastel
//
//  Created by Steven Troughton-Smith on 31/08/2021.
//  Copyright © 2021 Steven Troughton-Smith. All rights reserved.
//

import UIKit

extension UIRectEdge {
	static let centeredVertically = UIRectEdge.init(rawValue:1<<7)
	static let centeredHorizontally = UIRectEdge.init(rawValue:1<<8)
}

class STXHairlineDividerView: UIView {

	@objc var dividerColor = UIColor.clear {
		didSet {
			setNeedsDisplay()
		}
	}
	
	var borderMask:UIRectEdge = []
	
	init() {
		super.init(frame: .zero)
		
		backgroundColor = .clear
		dividerColor = .separator
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var frame: CGRect {
		didSet {
			setNeedsDisplay()
		}
	}
	
	// MARK: -
	
	override func draw(_ rect: CGRect) {
		
		var scale = 1.0
		
		if let screen = window?.screen {
			scale = screen.scale
		}
		
		let dividerWidth = 1.0/scale
		
		if backgroundColor != nil && backgroundColor != .clear {
			backgroundColor?.set()
			UIRectFill(bounds)
		}
		
		if dividerColor != .clear {
			dividerColor.set()
			
			if borderMask.contains(.top) == true {
				UIRectFill(CGRect(x: 0, y: 0, width: bounds.width, height: dividerWidth))
			}
			
			if borderMask.contains(.left) == true {
				UIRectFill(CGRect(x: 0, y: 0, width: dividerWidth, height: bounds.height))
			}
			
			if borderMask.contains(.bottom) == true {
				UIRectFill(CGRect(x: 0, y: bounds.height-dividerWidth, width: bounds.width, height: dividerWidth))
			}
			
			if borderMask.contains(.right) == true {
				UIRectFill(CGRect(x: bounds.width-dividerWidth, y: 0, width: dividerWidth, height: bounds.height))
			}
			
			if borderMask.contains(.centeredVertically) == true {
				UIRectFill(CGRect(x: bounds.midX-dividerWidth, y: 0, width: dividerWidth, height: bounds.height))
			}
			
			if borderMask.contains(.centeredHorizontally) == true {
				UIRectFill(CGRect(x: 0, y: bounds.midY-dividerWidth, width: bounds.width, height: dividerWidth))
			}
		}
		
	}
   
}
