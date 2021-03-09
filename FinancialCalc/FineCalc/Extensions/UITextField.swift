//
//  UITextField.swift
//  FinancialCal
//  Created by Aysha Arafath on 3/8/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//
import Foundation
import UIKit

extension UITextField {
    
    func setLeftView(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 5, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setAsDropdown(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 2, y: 8, width: 26, height: 14))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
    }
}
