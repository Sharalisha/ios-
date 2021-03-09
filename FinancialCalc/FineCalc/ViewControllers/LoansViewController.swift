//
//  SecondViewController.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/7/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import UIKit

class LoansViewController: UIViewController, UITextFieldDelegate, FineCalcKeyboardDelegate {

    @IBOutlet weak var principalAmountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var PeriodTextField: UITextField!
    @IBOutlet weak var monthlyInstallmentTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    /// Currently active text field
    var activeField : UITextField?
    
    /// Default offset
    var lastOffset : CGPoint?
    
    /// Height of the keyboard
    var keyboardHeight : CGFloat = 300
    
    /// Initial height of the content view
    var initialContentViewHeight : CGFloat = 0
    
    /// Space between scroll view and view bottom
    var bottomspace :CGFloat?
    
    /// Whether the keyboard is visible on not
    var keyboardVisible:Bool = false;
    
    /// Distance between two text fields (including the lable in betweeen)
    let distanceBetweenTwoTextFields: CGFloat = 73.3
    
    /// Last editable text field
    var lastField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contentViewHeight.constant = scrollView.frame.height
        initialContentViewHeight = contentViewHeight.constant
        
        bottomspace =
        self.view.frame.height - self.scrollView.frame.origin.y - self.scrollView.frame.height
        
        principalAmountTextField.setAsCustomKeyboard(delegate: self)
        principalAmountTextField.delegate = self
        interestRateTextField.setAsCustomKeyboard(delegate: self)
        interestRateTextField.delegate = self
        PeriodTextField.setAsCustomKeyboard(delegate: self)
        PeriodTextField.delegate = self
        monthlyInstallmentTextField.setAsCustomKeyboard(delegate: self)
        monthlyInstallmentTextField.delegate = self
        lastField = monthlyInstallmentTextField;
        
        // Hides the keyboard when tapped elsewhere
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(KeyboardWillHide)))
        
        restoreFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Register the notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(LoansViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoansViewController.keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        principalAmountTextField.delegate = self
        interestRateTextField.delegate = self
        PeriodTextField.delegate = self
        monthlyInstallmentTextField.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - User Interaction
    @IBAction func FieldValueChanged(_ sender: Any) {
        saveToDefaults()
    }

    @IBAction func onCalculate(_ sender: Any) {
        
        let emptyField = getTheEmptyField()
        
        if(emptyField == nil){
            return;
        }
        
        let p = Helpers.stringToDouble(number:principalAmountTextField.text ?? "0.0" )
        let r = (Helpers.stringToDouble(number:interestRateTextField.text ?? "0.0" ) / 100 )
        let t = Helpers.stringToDouble(number:PeriodTextField.text ?? "0.0" )
        let a = Helpers.stringToDouble(number:monthlyInstallmentTextField.text ?? "0.0" )
        
        var value:Double = 0.0
        
        if (emptyField == principalAmountTextField) {
            value = LoanCalculations.calculateLoanAmount(monthlyInstallment: a, interestRate: r, duration: t)
        }else if(emptyField == interestRateTextField){
            showErrorAlert(message: "Calculating Interest Rate is Not Supported");
            return;
        }else if(emptyField == PeriodTextField){
            value = LoanCalculations.calculateDuration(loanAmount: p, interestRate: r, monthlyInstallment: a)
        }else{
            value = LoanCalculations.calculateEMI(loanAmount: p, interestRate: r, duration: t)
        }
        
        print(value)
        emptyField?.text = String(String(format: "%.2f", value))
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
        
        if(PeriodTextField.text == ""){
            found  += 1
            emptyField = PeriodTextField
        }
        
        if(monthlyInstallmentTextField.text == ""){
            found  += 1
            emptyField = monthlyInstallmentTextField
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
        if(!keyboardVisible){
            UIView.animate(withDuration: 0.3, animations: {
                self.contentViewHeight.constant += self.keyboardHeight
            })
            keyboardVisible = true;
        }
        
        // Distance to the bottom from the selected textfield
        let distanceToBottom = self.scrollView.frame.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
        
        // How much to scroll up (distance between two ext fields is used so the next text field is also visible without scrolling)
        let collapseSpace = keyboardHeight - distanceToBottom - bottomspace! + self.distanceBetweenTwoTextFields
        
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
        if(activeField != lastField){
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset!.x, y: collapseSpace )
            })
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset!.x, y: collapseSpace - self.distanceBetweenTwoTextFields)
            })
        }
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentViewHeight.constant = self.initialContentViewHeight
        })
        UIView.animate(withDuration: 0.3, animations: {
        // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
        keyboardVisible = false;
    }
    
    // MARK: -  UI Text Field Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    // MARK: - User-Defaults
    let userDefaultPrincipalAmount = "LoansPrincipalAmount"
    let userDefaultInterestRate = "LoansInterestRate"
    let userDefaultPeriod = "LoansPeriod"
    let userDefaultMonthlyInstallment = "LoansMonthlyInstallment"
    
    private func saveToDefaults()
    {
        UserDefaults.standard.set(principalAmountTextField.text ?? "",forKey:userDefaultPrincipalAmount)
        UserDefaults.standard.set(interestRateTextField.text ?? "",forKey:userDefaultInterestRate)
        UserDefaults.standard.set(PeriodTextField.text ?? "",forKey:userDefaultPeriod)
        UserDefaults.standard.set(monthlyInstallmentTextField.text ?? "",forKey:userDefaultMonthlyInstallment)
        
        UserDefaults.standard.synchronize()
    }
    
    private func restoreFromDefaults()
    {
        var value:String = ""
        value = UserDefaults.standard.string(forKey:userDefaultPrincipalAmount) ?? ""
        principalAmountTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultInterestRate) ?? ""
        interestRateTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultPeriod) ?? ""
        PeriodTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultMonthlyInstallment) ?? ""
        monthlyInstallmentTextField.text = value
    }
}

