//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Илья Морозов on 21.12.2024.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
}
enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "X"
    case divdie = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divdie:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}


class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var calculationHistory: [CalculationHistoryItem] = []
    var calculations: [Calculation] = []
    let calculationHistoryStorage = CalculationHistoryStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLabel()
        calculations = calculationHistoryStorage.loadHistory()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        calculations = calculationHistoryStorage.loadHistory()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return }
        if buttonText == "," && resultLabel.text?.contains(",") == true { return }
        
        if resultLabel.text == "Ошибка" {
            resetLabel()
        }
        
        if resultLabel.text == "0" {
            resultLabel.text = buttonText
        } else {
            resultLabel.text?.append(buttonText)
        }
        sender.buttonAnimation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoryVC" {
            if let vc = segue.destination as? CalculationsListViewController {
                vc.calculations = calculations
            }
        }
    }
    
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text,
            let buttonOperation = Operation(rawValue: buttonText) else {
            return }
        
        guard let labelText = resultLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue else {return}
        resultLabel.text = buttonText
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        resetLabel()
        sender.buttonAnimation()
    }
    
    @IBAction func resultButtonPressed(_ sender: UIButton) {
        sender.buttonAnimation()
        guard
            let labelText = resultLabel.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue else {return}
        
        calculationHistory.append(.number(labelNumber))
        
        
        do {
            let result = try calculate()
            let newCalculation = Calculation(expression: calculationHistory, result: result)
            resultLabel.text = numberFormatter.string(from: NSNumber(value: result))
            calculations.append(newCalculation)
            calculationHistoryStorage.setHistory(calculation: calculations)
        } catch {
            resultLabel.text = "Ошибка"
            resultLabel.labelAnimation()
        }
        calculationHistory.removeAll()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        calculationHistory.removeAll()
        resetLabel()
        sender.buttonAnimation()
    }
    
    func calculate() throws-> Double {
        guard case .number(let firstNumber) = calculationHistory.first else { return 0}
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard case .operation(let operation) = calculationHistory[index],
                  case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        return currentResult
    }
    
    func resetLabel() {
        resultLabel.text = "0"
    }
}

extension UIButton {
    func buttonAnimation() {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1, 0.9, 1]
        scaleAnimation.keyTimes = [0, 0.3, 1]
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [1, 0.7, 1]
        opacityAnimation.keyTimes = [0, 0.3, 1]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        
        layer.add(animationGroup, forKey: "grooupAnimation")
    }
}

extension UILabel {
    func labelAnimation() {
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = CGPoint(x: center.x-5, y: center.y)
        positionAnimation.toValue = CGPoint(x: center.x, y: center.y)
        positionAnimation.duration = 0.1
        positionAnimation.repeatCount = 3
        layer.add(positionAnimation, forKey: "positionAnimation")
    }
}
