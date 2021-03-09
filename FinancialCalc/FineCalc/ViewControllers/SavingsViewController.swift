//
//  FirstViewController.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/7/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate, FineCalcKeyboardDelegate {

    
    // MARK: - Variables
    @IBOutlet weak var principalAmountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var futureValueTextField: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var paymentLable: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    /// Currently active text field
    var activeField : UITextField?
    
    /// Default offset
    var lastOffset : CGPoint?
    
    /// Initial height of the content view
    var initialViewHeight : CGFloat = 0
    
    /// Space between scroll view and view bottom
    var bottomSpace :CGFloat?
    
    /// Whether the keyboard is visible on not
    var keyboardShown:Bool = false;
    
    /// Last editable text field
    var lastTextField : UITextField?
    
    // MARK: - View Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize variables
        contentViewHeight.constant = scrollView.frame.height
        initialViewHeight = contentViewHeight.constant
        
        bottomSpace =
            self.view.frame.height - self.scrollView.frame.origin.y - self.scrollView.frame.height
        
        principalAmountTextField.setAsCustomKeyboard(delegate: self)
        principalAmountTextField.delegate = self
        interestRateTextField.setAsCustomKeyboard(delegate: self)
        interestRateTextField.delegate = self
        periodTextField.setAsCustomKeyboard(delegate: self)
        periodTextField.delegate = self
        futureValueTextField.setAsCustomKeyboard(delegate: self)
        futureValueTextField.delegate = self
        paymentTextField.setAsCustomKeyboard(delegate: self)
        paymentTextField.delegate = self
        
        
        // Hide payment textfield and lable and set future value field as the last text field
        paymentTextField.isHidden = true;
        paymentLable.isHidden = true
        lastTextField = futureValueTextField;
        
        // Hide the keyboard when outside area is touched
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(KeyboardWillHide)))
        
        restoreFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Register the notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(SavingsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SavingsViewController.keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        principalAmountTextField.delegate = self
        interestRateTextField.delegate = self
        periodTextField.delegate = self
        futureValueTextField.delegate = self
        paymentTextField.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Deregister the Notification observers
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - User Interactions
    
    // Handles Segment control Change
    @IBAction func calculationTypeChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            // 1 -> Compund interest savings with regular contribution
            paymentTextField.isHidden = false;
            paymentLable.isHidden = false;
            lastTextField = paymentTextField;
        default:
            // 0 -> Compund interest savings
            paymentTextField.isHidden = true;
            paymentLable.isHidden = true;
            lastTextField = futureValueTextField;
        }
    }
    
    @IBAction func calculateValue(_ sender: UIButton) {
        let emptyField = getTheEmptyField()
        
        if(emptyField == nil){
            return;
        }
        
        let p = Helpers.stringToDouble(number:principalAmountTextField.text ?? "0.0" )
        let r = (Helpers.stringToDouble(number:interestRateTextField.text ?? "0.0" ) / 100 )
        let t = Helpers.stringToDouble(number:periodTextField.text ?? "0.0" )
        let a = Helpers.stringToDouble(number:futureValueTextField.text ?? "0.0" )
        let d = Helpers.stringToDouble(number:paymentTextField.text ?? "0.0" )
        
        var value:Double = 0.0
        
        if (emptyField == principalAmountTextField){
            if(!paymentTextField.isHidden){
                value = SavingCalculations.CalculatePrincipalAmount(futureValue: a, interestRate: r, payment: d, duration: t)
            }
            else {
                value = SavingCalculations.CalculatePrincipalAmount(futureValue: a, interestRate: r, duration: t)
            }
        }else if(emptyField == interestRateTextField){
            if(!paymentTextField.isHidden){
                showErrorAlert(message: "Calculating Intrest for a Regular Contribution Savings is not supprted :(")
            }
            else {
                value = SavingCalculations.CalculateInterestRate(presentValue: p, futureValue: a, duration: t) * 100
            }
        }else if(emptyField == periodTextField){
            if(!paymentTextField.isHidden){
                value = SavingCalculations.CalculateTime(futureValue: a, presentValue: p, interestRate: r, payment: d)
            }
            else {
                value = SavingCalculations.CalculateTime(futureValue: a, presentValue: p, interestRate: r)
            }
        }else if(emptyField == futureValueTextField){
            if(!paymentTextField.isHidden){
                value = SavingCalculations.CalculateFutureValue(presentValue: p, interestRate: r, duration: t, payment: d)
            }
            else {
                value = SavingCalculations.CalculateFutureValue(presentValue: p, interestRate: r, duration: t)
            }
        }else {
            value = SavingCalculations.CalculateMonthlyPayment(futureValue: a, presentValue:p, interestRate: r, duration: t)
        }
        
        print(value)
        emptyField?.text = String(String(format: "%.2f", value))
    }
    
    @IBAction func FieldValueChanged(_ sender: Any) {
        saveToDefaults()
    }
    // MARK: - Helpers
    
    // Returns the empty text field or a message
    private func getTheEmptyField () -> UITextField?
    {
        var found = 0
        var emptyField:UITextField? = nil
        
        if(principalAmountTextField.text == ""){
            found += 1
            emptyField = principalAmountTextField
        }
        
        if(interestRateTextField.text == ""){
            found += 1
            emptyField = interestRateTextField
        }
        
        if(periodTextField.text == ""){
            found  += 1
            emptyField = periodTextField
        }
        
        if(futureValueTextField.text == ""){
            found  += 1
            emptyField = futureValueTextField
        }
        
        if( !paymentTextField.isHidden && paymentTextField.text == ""){
            found  += 1
            emptyField = paymentTextField
        }
        
        switch found {
        case 0:
            showErrorAlert(message: "All the fileds are filled")
            return nil
        case 1:
            return emptyField
        default:
            showErrorAlert(message: "More than one empty field found")
            return nil
        }
    }
    
    func showErrorAlert(message:String){
        let alertController = UIAlertController(title: "Error", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Fine-Calc Keyboard Delegate
    func NumberKeyPressed(key: Int) {return;}
    
    func BackspacePressed() {return;}
    
    func SymbolPressed(symbol: String) {return;}
    
    func HideKeyboard() {
        KeyboardWillHide()
    }
    
    @objc func KeyboardWillHide(){
        self.view.endEditing(true)
        activeField?.endEditing(true)
        activeField = nil
        return;
    }
    
    // MARK: - Keyboard Scroll
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // If the keyboard is not already visible
        // increase the content View's height by keyboards height
        if(!keyboardShown){
            UIView.animate(withDuration: 0.3, animations: {
                self.contentViewHeight.constant += 300
            })
            keyboardShown = true;
        }
        
        // Distance to the bottom from the selected textfield
        let distanceToBottom = self.scrollView.frame.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
        
        // How much to scroll up (distance between two ext fields is used so the next text field is also visible without scrolling)
        let collapseSpace = (300) - distanceToBottom - self.bottomSpace! + 73.3
        
        // If collapse space is less than 0 scroll to the top
        // This is to stop weird scroll placings when not hidden fields were selected
        if collapseSpace < 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            })
            return
        }
        
        // If not last text field scroll as is
        // else reduce the "distance between two text fields" value we added before
        //  to stop having whitespace when last field is selcted
        if(activeField != lastTextField){
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset!.x, y: collapseSpace )
            })
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset!.x, y: collapseSpace - 73.3)
            })
        }
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        print("keyboard hidden")
        UIView.animate(withDuration: 0.3, animations: {
            self.contentViewHeight.constant = self.initialViewHeight
        })
        UIView.animate(withDuration: 0.3, animations: {
        // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
        keyboardShown = false;
    }
    
    // MARK: -  UI Text Field Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        print("Started Editing")
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    // MARK: - User-Defaults
    
    let userDefaultPrincipalAmount = "SavingsPrincipalAmount"
    let userDefaultInterestRate = "SavingsInterestRate"
    let userDefaultPeriod = "SavingsPeriod"
    let userDefaultFutureValue = "SavingsFutureValue"
    let userDefaultPayment = "SavingsPayment"
    
    private func saveToDefaults()
    {
        print("Defaults updated")
        UserDefaults.standard.set(principalAmountTextField.text ?? "",forKey:userDefaultPrincipalAmount)
        UserDefaults.standard.set(interestRateTextField.text ?? "",forKey:userDefaultInterestRate)
        UserDefaults.standard.set(periodTextField.text ?? "",forKey:userDefaultPeriod)
        UserDefaults.standard.set(futureValueTextField.text ?? "",forKey:userDefaultFutureValue)
        UserDefaults.standard.set(paymentTextField.text ?? "",forKey:userDefaultPayment)
        
        UserDefaults.standard.synchronize()
    }
    
    private func restoreFromDefaults()
    {
        var value:String = ""
        print("Defaults restored")
        value = UserDefaults.standard.string(forKey:userDefaultPrincipalAmount) ?? ""
        principalAmountTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultInterestRate) ?? ""
        interestRateTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultPeriod) ?? ""
        periodTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultFutureValue) ?? ""
        futureValueTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultPayment) ?? ""
        paymentTextField.text = value
    }
}

