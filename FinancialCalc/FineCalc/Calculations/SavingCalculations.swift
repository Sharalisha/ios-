//
//  SavingCalculations.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/8/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import Foundation

// MARK: - Savings Related Calculations
class SavingCalculations {
    
    /// Calculate the Principal Amount
    static func CalculatePrincipalAmount(futureValue:Double, interestRate:Double, duration:Double, compounds:Double = 12) -> Double
    {
        return (futureValue / pow((1 + (interestRate/compounds)), (duration * compounds)))
    }
    
    /// Calculate the Principal Amount
    static func CalculatePrincipalAmount(futureValue:Double, interestRate:Double, payment:Double, duration:Double, compounds:Double = 12) -> Double
    {
        let futureValue = futureValue - CalculateFutureValueOfASeries(payment: payment, interestRate: interestRate, duration: duration)
        return CalculatePrincipalAmount(futureValue:futureValue, interestRate: interestRate, duration: duration)
    }
    
    /// Calculate the Duration
    static func CalculateTime (futureValue:Double, presentValue:Double, interestRate:Double, compounds:Double = 12) -> Double
    {
        let res =  (log(futureValue / presentValue) / (compounds * log (1 + (interestRate / compounds))))
        
        return Double(res)
    }
    /// Calculate the Duration
    static func CalculateTime (futureValue:Double, presentValue:Double, interestRate:Double, payment:Double, compounds:Double = 12) -> Double
    {
        let res =  ((log (futureValue + (payment * compounds / interestRate)) - log(presentValue + (payment * compounds / interestRate))) / (compounds * log(futureValue + (interestRate / compounds))))
        return Double(res)
    }
    
    /// Calculate the Interest Rate
    static func CalculateInterestRate(presentValue:Double, futureValue:Double, duration:Double, compounds:Double = 12) -> Double
    {
        print(pow((futureValue / presentValue),(1 / (compounds * duration))))
        return ( compounds * (pow((futureValue / presentValue),(1 / (compounds * duration))) - 1))
    }
    
    /// Calculate the Future Value
    static func CalculateFutureValue(presentValue:Double, interestRate:Double, duration:Double, compounds:Double = 12) -> Double
    {
        let cmpIntrest = CalculateCompundInterest(presentValue: presentValue, interestRate: interestRate, duration: duration)
        print("interest \(cmpIntrest)")
        return (presentValue + cmpIntrest)
    }
    
    /// Calculate the Future Value
    static func CalculateFutureValue(presentValue:Double, interestRate:Double, duration:Double, payment:Double, compounds:Double = 12) -> Double
    {
        return (presentValue + CalculateCompundInterest(presentValue: presentValue, interestRate: interestRate, duration: duration) + CalculateFutureValueOfASeries(payment: payment, interestRate: interestRate, duration: duration))
    }
    
    /// Calculate the Monthly Payment
    static func CalculateMonthlyPayment(futureValue:Double, presentValue:Double, interestRate:Double, duration:Double, compounds:Double = 12) -> Double
    {
        let futureValue = futureValue - CalculateFutureValue(presentValue: presentValue, interestRate: interestRate, duration: duration)
        return CalculatePaymentOfASeries(futureValue: futureValue, interestRate: interestRate, duration: duration)
    }
    
    /// Calculate the Compund Interest
    static private func CalculateCompundInterest (presentValue:Double, interestRate:Double, duration:Double, compounds:Double = 12) -> Double
    {
        let res = (1 + (interestRate / compounds))
        let p1 = (pow(res, (compounds * duration)) - 1)
        print(p1)
        return (presentValue * p1)
    }
    
    /// Calculate the Future Value of a series
    static private func CalculateFutureValueOfASeries(payment:Double,interestRate:Double, duration:Double, compounds:Double = 12) -> Double
    {
        return payment == 0.0 ? 0.0 : (payment * ((pow((1 + (interestRate / compounds)),(compounds * duration))) - 1) / (interestRate / compounds));
    }
    
    /// Calculate the Payment
    static private func CalculatePaymentOfASeries(futureValue:Double, interestRate:Double, duration:Double, compounds:Double = 12) -> Double
    {
        return (futureValue / (((pow((1 + (interestRate / compounds)), (compounds * duration))) - 1) / (interestRate / compounds)))
    }
}
