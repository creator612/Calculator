//
//  ViewController.swift
//  Calculator
//
//  Created by 이소영 on 2022/05/31.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Caclulator (count = \(calculatorCount))")
        brain.addUnaryOperation(symbol: "Z") { [ weak weakSelf = self ] in
            weakSelf?.display.textColor = UIColor.red
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Caclulator left the heap (count = \(calculatorCount))")
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle! //UIButon state should be "Default"
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    
}

