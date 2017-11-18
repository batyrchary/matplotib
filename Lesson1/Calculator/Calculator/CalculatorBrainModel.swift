//
//  CalculatorBrainModel.swift
//  Calculator
//
//  Created by Batyr Charyyev on 11/15/17.
//  Copyright © 2017 Batyr Charyyev. All rights reserved.
//

import Foundation

func multiply(ar1: Double, ar2: Double)-> Double{
    return ar1*ar2
}

class CalculatorBrainModel{
    
    
    private var accumulator: Double = 0.0
    func setOperand(operand: Double){
        accumulator=operand
    }
    
    private var operations : Dictionary<String, Operation>=[
        "π": Operation.Constant(M_PI),
        "e":  Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "+/-": Operation.UnaryOperation({-$0}),
        "%": Operation.UnaryOperation({$0/100}),
        "x": Operation.BinaryOperation(multiply),
        "+": Operation.BinaryOperation({$0 + $1}),
        "-": Operation.BinaryOperation({return $0 - $1 }),
        "÷": Operation.BinaryOperation({ (op1, op2) in return op1 / op2 }),
        "=": Operation.Equals

    ]

    
    private enum Operation{
            case Constant(Double)
            case UnaryOperation((Double) -> Double) //this is function taking double and returning double
            case BinaryOperation((Double, Double) -> Double)
            case Equals
    }
/////////////////////////////////
    
    private var ass:Double=0.0
    private var previous=""
    
    func performOperation(symbol: String)
    {
        if let operation = operations[symbol]
        {
            if(previous != symbol)
            {
                ass=0
                pending=nil
            }
            previous=symbol
            switch operation
            {
                case Operation.Constant(let associatedvalue):
                    accumulator=associatedvalue
                case Operation.UnaryOperation(let assfunction):
                    accumulator=assfunction(accumulator)
                case Operation.BinaryOperation(let assfunction):
                    executebinarypendingOp()
                    pending=PendingOperationInfo (binaryFunction: assfunction, firstOperand: accumulator)
                case Operation.Equals:
                    if(ass==0)
                    {
                            ass=accumulator
                    }
                    else
                    {
                            pending!.firstOperand=ass
                    }
                    
                    executebinarypendingOp()
            }
        }
    }
    
    private func executebinarypendingOp()
    {
        if pending != nil
        {
            accumulator=pending!.binaryFunction(pending!.firstOperand,accumulator)
           // pending=nil
        }
    }
    
    private var pending: PendingOperationInfo?
    
    private struct PendingOperationInfo
    {
        var binaryFunction:(Double, Double)->Double
        var firstOperand: Double
    }
    
    
////////////////////////////////////
    
    public func resetAccumulator()
    {
        accumulator=0.0
        pending=nil
        ass=0
    }
    
    var result: Double
    {
        get
        {
            return accumulator
        }
    }
}
