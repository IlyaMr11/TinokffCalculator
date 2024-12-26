//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Илья Морозов on 23.12.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
    
        
    var calculations: [Calculation] = []
    let calculationHistoryStorage = CalculationHistoryStorage()
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        print(calculations.count)
    }
    
    

    @IBAction func clearHsitory(_ sender: Any) {
        CalculationHistoryStorage.deleteHistory()
        calculations.removeAll()
        tableView.reloadData()
        print(calculations.count)
    }
    
    
    private func expressionToString(_ expression: [CalculationHistoryItem]) -> String {
        var result = ""
        
        for operand in expression {
            switch operand {
            case let .number(value):
                result += String(value)
            case let .operation(value):
                result += value.rawValue
            }
        }
        return result
    }
}

extension CalculationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let historyItem = calculations[indexPath.row]
        cell.configure(with: expressionToString(historyItem.expression), result: String(historyItem.result))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
