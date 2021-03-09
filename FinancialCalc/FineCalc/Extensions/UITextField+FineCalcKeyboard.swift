//
//  UITextField+CustomKeyboard.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 2/9/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import Foundation
import UIKit

private var keyboardDelegate: FineCalcKeyboardDelegate? = nil

// MARK: - This extension can be used to make UITextFields as a part of the Fine Calc Keyboard.
extension UITextField: FineCalcKeyboardDelegate {
    
    /// Sets the text field as a part of fine-calc keyboard.
    ///
    /// - Parameter delegate: The deligate
    func setAsCustomKeyboard(delegate: FineCalcKeyboardDelegate?) {
        let keyboard = FinancialCalKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        self.inputView = keyboard
        keyboardDelegate = delegate
        keyboard.delegate = self
    }
    
    
    /// Unsets the fine-calc keyboard from the text field
    func unsetAsCustomKeyboard() {
        if let keyboard = self.inputView as? FinancialCalKeyboard {
            keyboard.delegate = nil
        }
        self.inputView = nil
        keyboardDelegate = nil
    }
    
    /// Handles the numeric key press.
    ///
    /// - Parameter key: The numeric key
    internal func NumberKeyPressed(key: Int) {
        
        switch key {
        case 0:
            if(self.text == "0"){
                break;
            }
            self.insertText(String(key))
        default:
            self.insertText(String(key))
        }
        
        keyboardDelegate?.NumberKeyPressed(key: key)
    }
    
    
    /// Handles the backspace key press
    internal func BackspacePressed() {
        self.deleteBackward()
        keyboardDelegate?.BackspacePressed()
    }
    
    
    /// Handles the symbol key press. It inserts the
    /// symbol to the text field after validating
    ///
    /// - Parameter symbol: The symbol
    internal func SymbolPressed(symbol: String) {
        if(symbol == "-" && self.text == ""){
            self.insertText(String(symbol))
        }
        
        // If the symbol is '.' check if the field already have a .
        if(symbol == "." && !(self.text?.contains(".") ?? false)){
            if(self.text == ""){
                self.insertText("0")
            }
            self.insertText(String(symbol))
        }
        keyboardDelegate?.SymbolPressed(symbol: symbol)
    }
    
    internal func HideKeyboard() {
        print("hidden textf controller")
        keyboardDelegate?.HideKeyboard()
    }
}
