//
//  Extensions.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult func loadViewFromNib() -> UIView {
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let views = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        setNeedsUpdateConstraints()
        
        return view
    }
}
