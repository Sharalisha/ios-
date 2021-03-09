//
//  MortgageCalculations.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/9/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import Foundation

class MortgageCalculations {
    
    /// Calculates the Equated Monthly Payment of an Loan
    static func calculateEMI(loanAmount:Double, interestRate:Double, duration:Double, downPayment:Double = 0.0) -> Double
    {
        return ((loanAmount - downPayment) * interestRate * pow((1 + interestRate),duration) / (pow((1 + interestRate),duration) - 1))
    }
    
    /// Calculates the Loan Amount  of an Loan
    static func calculateLoanAmount(monthlyInstallment:Double, interestRate:Double, duration:Double, downPayment:Double = 0.0) -> Double
    {
        return (monthlyInstallment / (interestRate * pow((1 + interestRate),duration) / (pow((1 + interestRate),duration) - 1))) + downPayment
    }
    
    /// Calculates the Duration of an Loan
    static func calculateDuration(loanAmount:Double, interestRate:Double, monthlyInstallment:Double, downPayment:Double = 0.0) -> Double
    {
        let val = ((log(monthlyInstallment) - log (monthlyInstallment - ((loanAmount - downPayment) * interestRate))) / log(1 + interestRate))
        return Double(val)
    }
    
    /// Calculate the required down payment
    static func calculateDownPayment (principleAmount:Double, interestRate:Double, monthlyInstallment:Double, mortgage:Double) -> Double
    {
        return principleAmount - calculateLoanAmount(monthlyInstallment: monthlyInstallment, interestRate: interestRate, duration: mortgage)
    }
}
