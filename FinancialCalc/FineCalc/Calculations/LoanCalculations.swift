//
//  LoanCalculations.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/9/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import Foundation
class LoanCalculations {
    
    /// Calculates the Equated Monthly Payment of an Loan
    static func calculateEMI(loanAmount:Double, interestRate:Double, duration:Double) -> Double
    {
        return (loanAmount * interestRate * pow((1 + interestRate),duration) / (pow((1 + interestRate),duration) - 1))
    }
    
    /// Calculates the Loan Amount  of an Loan
    static func calculateLoanAmount(monthlyInstallment:Double, interestRate:Double, duration:Double) -> Double
    {
        return (monthlyInstallment / (interestRate * pow((1 + interestRate),duration) / (pow((1 + interestRate),duration) - 1)))
    }
    
    /// Calculates the Duration of an Loan
    static func calculateDuration(loanAmount:Double, interestRate:Double, monthlyInstallment:Double) -> Double
    {
        let val = ((log(monthlyInstallment) - log (monthlyInstallment - (loanAmount * interestRate))) / log(1 + interestRate))
        return Double(val)
    }
}
