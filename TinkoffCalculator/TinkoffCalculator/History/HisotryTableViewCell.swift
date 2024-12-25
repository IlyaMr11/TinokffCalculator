//
//  HisotryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Илья Морозов on 25.12.2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var expressionLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    func configure(with expression: String, result: String) {
        expressionLabel.text = expression
        resultLabel.text = result
    }
    
}
