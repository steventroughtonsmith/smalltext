//
//  STXFontButton.swift
//  smalltext
//
//  Created by Steven Troughton-Smith on 29/01/2021.
//

import UIKit

class STXFontButton: UIButton {
    
    let visualEffectView = STXVisualEffectView(blurStyle: .prominent)

    let label = UILabel()
    
    var documentFont = UIFont.systemFont(ofSize: UIFloat(13)) {
        didSet {
            label.text = "\(documentFont.fontName) \(documentFont.pointSize)"
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            visualEffectView.backgroundColor = isHighlighted ? .systemFill : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
            
        layer.borderWidth = 1
        layer.borderColor = UIColor.opaqueSeparator.withAlphaComponent(0.2).cgColor
        
        addSubview(visualEffectView)
        
        label.font = UIFont.systemFont(ofSize: UIFloat(13))
        label.textAlignment = .center
        label.textColor = UIColor.label.withAlphaComponent(0.5)

        visualEffectView.contentView.addSubview(label)
        
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
        
        let inset = UIFloat(4)
        let cornerRadius = UIFloat(8)
        
        label.frame = bounds.insetBy(dx: inset, dy: inset)
        
        layer.cornerRadius = cornerRadius
    }
}
