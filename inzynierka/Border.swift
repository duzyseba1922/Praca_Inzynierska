//
//  Border.swift
//  inzynierka
//
//  Created by Duży Seba on 02/12/2019.
//  Copyright © 2019 Sebastian Niestój. All rights reserved.
//

import UIKit

@IBDesignable class BorderView : UIButton {
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
        layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
