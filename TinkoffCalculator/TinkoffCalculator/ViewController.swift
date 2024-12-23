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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLabel()
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
    }
    
    @IBAction func ToHistoryVC(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationsListViewController = sb.instantiateViewController(withIdentifier: "CalculationsListViewController")
        
        if let vc = calculationsListViewController as? CalculationsListViewController {
            if calculationHistory.isEmpty {
                vc.resultText = "Не было вычислений"
            } else {
                vc.resultText = resultLabel.text ?? "0"
            }

        }
        
        navigationController?.pushViewController(calculationsListViewController, animated: true)
        
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
    }
    
    @IBAction func resultButtonPressed() {
        guard
            let labelText = resultLabel.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue else {return}
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            resultLabel.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            resultLabel.text = "Ошибка"
        }
        
        
        
        calculationHistory.removeAll()
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        resetLabel()
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

