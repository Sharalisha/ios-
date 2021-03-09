//
//  MortgagesViewController.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/9/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import UIKit

class MortgagesViewController: UIViewController, UITextFieldDelegate, FineCalcKeyboardDelegate  {

    @IBOutlet weak var principalAmountTextField: UITextField!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var monthlyInstallmentTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    /// Currently active text field
    var activeField : UITextField?
    
    /// Default offset
    var lastOffset : CGPoint?
    
    /// Height of the keyboard
    var keyboardHeight :CGFloat = 300
    
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
    
    // MARK: - View Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentViewHeight.constant = scrollView.frame.height
        initialContentViewHeight = contentViewHeight.constant
        
        bottomspace =
        self.view.frame.height - self.scrollView.frame.origin.y - self.scrollView.frame.height
        
        principalAmountTextField.setAsCustomKeyboard(delegate: self)
        principalAmountTextField.delegate = self
        downPaymentTextField.setAsCustomKeyboard(delegate: self)
        downPaymentTextField.delegate = self
        interestRateTextField.setAsCustomKeyboard(delegate: self)
        interestRateTextField.delegate = self
        periodTextField.setAsCustomKeyboard(delegate: self)
        periodTextField.delegate = self
        monthlyInstallmentTextField.setAsCustomKeyboard(delegate: self)
        monthlyInstallmentTextField.delegate = self
        
        lastField = monthlyInstallmentTextField;
        
        // Hides the keyboard when tapped elsewhere
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(KeyboardWillHide)))
        
        restoreFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Register the notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(MortgagesViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MortgagesViewController.KeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        principalAmountTextField.delegate = self
        downPaymentTextField.delegate = self
        interestRateTextField.delegate = self
        periodTextField.delegate = self
        monthlyInstallmentTextField.delegate = self
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Deregister the Notification observers
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
        let r = (Helpers.stringToDouble(number:interestRateTextField.text ?? "0.0" ) / 100 / 12 )
        let t = (Helpers.stringToDouble(number:periodTextField.text ?? "0.0" ) * 12 )
        let emi = Helpers.stringToDouble(number:monthlyInstallmentTextField.text ?? "0.0" )
        let d = Helpers.stringToDouble(number:downPaymentTextField.text ?? "0.0" )
        
        var value:Double = 0.0
        
        if (emptyField == principalAmountTextField) {
            value = MortgageCalculations.calculateLoanAmount(monthlyInstallment: emi, interestRate: r, duration: t, downPayment: d)
        }else if(emptyField == interestRateTextField){
            showErrorAlert(message: "Calculating Interest Rate is Not Supported");
        }else if(emptyField == periodTextField){
            value = MortgageCalculations.calculateDuration(loanAmount: p, interestRate: r, monthlyInstallment: emi, downPayment: d)
        }else if(emptyField == monthlyInstallmentTextField){
            value = MortgageCalculations.calculateEMI(loanAmount: p, interestRate: r, duration: t, downPayment: d)
        }else {
            value = MortgageCalculations.calculateDownPayment(principleAmount: p, interestRate: r, monthlyInstallment: emi, mortgage: t)
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
        
        if(periodTextField.text == ""){
            found  += 1
            emptyField = periodTextField
        }
        
        if(downPaymentTextField.text == ""){
            found  += 1
            emptyField = downPaymentTextField
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
        // How much to scroll up (distance between two text fields is used so the next text field is also visible without scrolling)
        let collapseSpace = keyboardHeight - distanceToBottom - self.bottomspace! + self.distanceBetweenTwoTextFields
        
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
    
    @objc func KeyboardHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentViewHeight.constant = self.initialContentViewHeight
        })
        UIView.animate(withDuration: 0.3, animations: {
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
    let userDefaultPrincipalAmount = "MortgagesPrincipalAmount"
    let userDefaultInterestRate = "MortgagesInterestRate"
    let userDefaultPeriod = "MortgagesPeriod"
    let userDefaultMonthlyInstallment = "MortgagesMonthlyInstallment"
    let userDefaultDownPayment = "MortgagesDownPayment"
    
    private func saveToDefaults()
    {
//        print("Defaults updated")
        UserDefaults.standard.set(principalAmountTextField.text ?? "",forKey:userDefaultPrincipalAmount)
        UserDefaults.standard.set(interestRateTextField.text ?? "",forKey:userDefaultInterestRate)
        UserDefaults.standard.set(periodTextField.text ?? "",forKey:userDefaultPeriod)
        UserDefaults.standard.set(monthlyInstallmentTextField.text ?? "",forKey:userDefaultMonthlyInstallment)
        UserDefaults.standard.set(downPaymentTextField.text ?? "",forKey:userDefaultDownPayment)
        
        UserDefaults.standard.synchronize()
    }
    
    private func restoreFromDefaults()
    {
        var value:String = ""
//        print("Defaults restored")
        value = UserDefaults.standard.string(forKey:userDefaultPrincipalAmount) ?? ""
        principalAmountTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultInterestRate) ?? ""
        interestRateTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultPeriod) ?? ""
        periodTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultMonthlyInstallment) ?? ""
        monthlyInstallmentTextField.text = value
        value = UserDefaults.standard.string(forKey:userDefaultDownPayment) ?? ""
        downPaymentTextField.text = value
    }
}
