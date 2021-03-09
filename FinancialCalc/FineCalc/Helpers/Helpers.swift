//
//  Helpers.swift
//  FinancialCal
//
//  Created by Aysha Arafath on 3/8/20.
//  Copyright © 2020 Aysha Arafath. All rights reserved.
//

import Foundation
public class Helpers{
    
    /// Converts a string to an Double Number
    /// 
    /// - Parameter number: The number as a string
    /// - Returns: The number as a Double
    static func stringToDouble(number:String) -> Double
    {
        return Double(number) ?? 0.0
    }
    
    static func roundDouble (value:Double, decimalPoints:Int) -> Double
    {
        return Double(
            Int(
                floor(
                    (value * pow(Double(10.0),Double(decimalPoints)))
                )
            )
        ) / pow(10,Double(decimalPoints))
    }
}
