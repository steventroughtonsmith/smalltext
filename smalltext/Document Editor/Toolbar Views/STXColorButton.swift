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
            visualEffectView.backgroundColor = isHighlighted ? .systemFill : .clear
        }
    }

    let visualEffectView = STXVisualEffectView(blurStyle: .prominent)
    let colorSwatch = UIView()
    let label = UILabel()
    let glyph = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        
        glyph.contentMode = .scaleAspectFit
        glyph.tintColor = UIColor.label.withAlphaComponent(0.5)

        colorSwatch.backgroundColor = color
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.opaqueSeparator.withAlphaComponent(0.2).cgColor
        
        colorSwatch.layer.borderWidth = 1
        colorSwatch.layer.borderColor = UIColor.opaqueSeparator.withAlphaComponent(0.2).cgColor
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
