//
//  STXColorButton.swift
//  smalltext
//
//  Created by Steven Troughton-Smith on 29/01/2021.
//

import UIKit

class STXColorButton: UIButton {
    
    var color = UIColor.black {
        didSet {
            colorSwatch.backgroundColor = color
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
			visualEffectView.contentView.backgroundColor = isHighlighted ? .separator : .clear
        }
    }

    let visualEffectView = STXVisualEffectView(blurStyle: .systemThickMaterial)
    let colorSwatch = UIView()
    let label = UILabel()
    let glyph = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        
        glyph.contentMode = .scaleAspectFit
        glyph.tintColor = UIColor.label

        colorSwatch.backgroundColor = color
        
        layer.borderWidth = 1.0 / UIScreen.main.scale
        layer.borderColor = UIColor.separator.cgColor
        
		colorSwatch.layer.borderWidth = 1.0 / UIScreen.main.scale
        colorSwatch.layer.borderColor = UIColor.separator.cgColor
        colorSwatch.isUserInteractionEnabled = false
        
        addSubview(visualEffectView)
        addSubview(colorSwatch)
        
        label.font = UIFont.systemFont(ofSize: UIFloat(13))
        label.textAlignment = .center

        visualEffectView.addContentView(glyph)
        visualEffectView.isUserInteractionEnabled = false
    }
    
    convenience init() {
        self.init(frame:.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	// MARK: -
	
	override func tintColorDidChange() {
		colorSwatch.layer.borderColor = UIColor.separator.cgColor
		layer.borderColor = UIColor.separator.cgColor
	}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        visualEffectView.frame = bounds
        
        let swatchSize = bounds.height
        let inset = UIFloat(4)
        let cornerRadius = UIFloat(8)

        colorSwatch.frame = CGRect(x: bounds.maxX-swatchSize, y: 0, width: swatchSize, height: swatchSize).insetBy(dx: inset, dy: inset)
        glyph.frame = CGRect(x: inset, y: 0, width: bounds.maxX-swatchSize, height: bounds.height).insetBy(dx: inset, dy: inset)
        
        layer.cornerRadius = cornerRadius
        colorSwatch.layer.cornerRadius = colorSwatch.bounds.midY
    }
}
