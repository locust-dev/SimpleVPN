//
//  Extensions.swift
//  SimpleVPN
//
//  Created by Ilya Turin on 18.11.2021.
//

import UIKit

extension UIView {
    
    func addSubviewWithAutoLayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}
