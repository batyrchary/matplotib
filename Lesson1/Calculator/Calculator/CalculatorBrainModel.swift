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
func fact(ar1: Double)-> Double{
    var ret : Double = 1
    if ar1 < 0
    {
        return 0
    }
    var counter : Double = ar1
    while(counter > 0)
    {
        ret=ret*counter
        counter=counter-1
    }
    
    return ret
}

class CalculatorBrainModel{
    
    private var internalProgram = [AnyObject]()
    
    private var accumulator: Double = 0.0
    func setOperand(operand: Double){
        accumulator=operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations : Dictionary<String, Operation>=[
        "π": Operation.Constant(M_PI),
        "e":  Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "cosh": Operation.UnaryOperation(cosh),
        "sinh": Operation.UnaryOperation(sinh),
        "tan": Operation.UnaryOperation(tan),
        "tanh": Operation.UnaryOperation(tanh),
        
        "ln": Operation.UnaryOperation(log),
        "log10": Operation.UnaryOperation(log10),
        "log2": Operation.UnaryOperation(log2),
        "!": Operation.UnaryOperation(fact),
        "+/-": Operation.UnaryOperation({-$0}),
        "%": Operation.UnaryOperation({$0/100}),
        "x": Operation.BinaryOperation(multiply),
        "+": Operation.BinaryOperation({$0 + $1}),
        "xʸ": Operation.BinaryOperation(pow),
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
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol]
        {
           
            
            switch operation
            {
                case Operation.Constant(let associatedvalue):
                    accumulator=associatedvalue
                case Operation.UnaryOperation(let assfunction):
                    accumulator=assfunction(accumulator)
                case Operation.BinaryOperation(let assfunction):
                    if(previous != symbol)
                    {
                        if(previous != "=")
                        {
                            executebinarypendingOp()
                        }
                        print("girdim")
                        ass=0
                        pending=nil
                    }
                    previous=symbol
                    executebinarypendingOp()
                    pending=PendingOperationInfo (binaryFunction: assfunction, firstOperand: accumulator)
                case Operation.Equals:
                    if(ass==0)
                    {
                            ass=accumulator
                    }
                    else
                    {
                        if(pending != nil)
                        {
                            pending!.firstOperand=ass
                            if(previous=="÷" || previous=="-")
                            {
                               
                                var temp:Double=pending!.firstOperand
                                pending!.firstOperand=accumulator
                                accumulator=temp
                                print(temp)
                            }
                        }
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
    
    typealias Propertylist = AnyObject
    //var program : AnyObject
    //typealias is same as typedef, so our object is of type propertylist and also of type Anyobject
    var program : Propertylist
    {
        get{
            return internalProgram as CalculatorBrainModel.Propertylist
        }
        set
        {
            resetAccumulator()
            if let arrayOfOps = newValue as? [AnyObject]
            {
                for op in arrayOfOps
                {
                    if let operand = op as? Double
                    {
                        setOperand(operand: operand)
                    }
                    else if let operations = op as? String
                    {
                        performOperation(symbol: operations)
                    }
                }
            }
        }
    }
 
    
    public func fit(his: String)->String
    {
        let size = his.count
        
        var str :String = his
        if(size>10)
        {
           // let sub_hism = str.suffix(10)
            //str=String(sub_hism)
            return String(his.suffix(10))
        }
        
        return his
//        return str
       // return String(his[size...])
    }
    
    
    public func resetAccumulator()
    {
        accumulator=0.0
        pending=nil
        ass=0
        internalProgram.removeAll()
    }
    
    var result: Double
    {
        get
        {
            return accumulator
        }
    }
}
