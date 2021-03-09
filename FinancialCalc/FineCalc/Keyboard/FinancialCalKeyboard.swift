//
//  FineCalcKeyboard.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/7/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import UIKit

class FinancialCalKeyboard: UIView {
    
    // TODO: -  Remove these if not used
    // MARK: - Number Keys
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    
    // MARK: - Special Keys
    @IBOutlet weak var buttonPoint: UIButton!
    @IBOutlet weak var buttonHide: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    // MARK: - Variable Initialization
    weak var delegate: FineCalcKeyboardDelegate?
    
    // MARK: - View Initialization and lifecycle
    override init(frame: CGRect) {
      super.init(frame: frame)
      initializeKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initializeKeyboard()
    }
    
    func initializeKeyboard() {
           let xibFileName = "FinancialCalKeyboard"
           let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0]
             as! UIView
           self.addSubview(view)
           view.frame = self.bounds
     }
    
    // MARK: - Button actions
     @IBAction func numericButtonPressed(_ sender: UIButton) {
       self.delegate?.NumberKeyPressed(key: sender.tag)
     }

     @IBAction func backspacePressed(_ sender: AnyObject) {
       self.delegate?.BackspacePressed()
     }
    
     @IBAction func symbolWasPressed(_ sender: UIButton) {
       if let symbol = sender.titleLabel?.text, symbol.count > 0 {
         self.delegate?.SymbolPressed(symbol: symbol)
       }
     }
    
    @IBAction func retractKeyboardPressed(_ sender: Any) {
        print("hidden keyb controller")
        self.delegate?.HideKeyboard()
    }
    
}

@objc protocol FineCalcKeyboardDelegate {
    
    /// Numeric key of the keyboard is pressed
    ///
    /// - Parameter key : The number  key which was pressed
    func NumberKeyPressed(key: Int)
    
    /// Backspace key is pressed
    func BackspacePressed()
    
    /// Symbol key is pressed
    func SymbolPressed(symbol: String)
    
    /// Hide Keyboard button is pressed
    func HideKeyboard()
}

