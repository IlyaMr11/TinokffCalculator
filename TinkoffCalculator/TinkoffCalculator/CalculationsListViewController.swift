//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Илья Морозов on 23.12.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
    var resultText: String?
        
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var historyResults: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = resultText
    }
    
    @IBAction func backToCalculator(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
