//
//  InputView.swift
//  chatApp
//
//  Created by Shravan Sukumar on 14/07/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

class InputView: UIView {

    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
}
