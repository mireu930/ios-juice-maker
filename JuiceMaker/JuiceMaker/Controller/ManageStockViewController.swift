//
//  ManageStockViewController.swift
//  JuiceMaker
//
//  Created by 미르 & 미성
//

import UIKit

final class ManageStockViewController: UIViewController {
    private let fruitStore = FruitStore.shared
    
    @IBOutlet weak private var strawberryStockLabel: UILabel!
    @IBOutlet weak private var bananaStockLabel: UILabel!
    @IBOutlet weak private var pineappleStockLabel: UILabel!
    @IBOutlet weak private var mangoStockLabel: UILabel!
    @IBOutlet weak private var kiwiStockLabel: UILabel!
    
    @IBOutlet weak private var strawberryStepper: UIStepper!
    @IBOutlet weak private var bananaStepper: UIStepper!
    @IBOutlet weak private var pineappleStepper: UIStepper!
    @IBOutlet weak private var kiwiStepper: UIStepper!
    @IBOutlet weak private var mangoStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @IBAction private func closedTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    private func configureUI() {
        let firstStock = fruitStore.fruitStock.compactMapValues { String($0) }
        let secondStock = fruitStore.fruitStock.compactMapValues { Double($0) }
        
        strawberryStockLabel.text = firstStock[.strawberry]
        strawberryStepper.value = secondStock[.strawberry] ?? 0
        bananaStockLabel.text = firstStock[.banana]
        bananaStepper.value = secondStock[.banana] ?? 0
        pineappleStockLabel.text = firstStock[.pineapple]
        pineappleStepper.value = secondStock[.pineapple] ?? 0
        kiwiStockLabel.text = firstStock[.kiwi]
        kiwiStepper.value = secondStock[.kiwi] ?? 0
        mangoStockLabel.text = firstStock[.mango]
        mangoStepper.value = secondStock[.mango] ?? 0
    }
    
    @IBAction private func stepperTapped(_ sender: UIStepper) {
        switch sender {
        case strawberryStepper:
            fruitStore.updateFruitStock(fruit: .strawberry, num: UInt(sender.value))
        case bananaStepper:
            fruitStore.updateFruitStock(fruit: .banana, num: UInt(sender.value))
        case pineappleStepper:
            fruitStore.updateFruitStock(fruit: .pineapple, num: UInt(sender.value))
        case kiwiStepper:
            fruitStore.updateFruitStock(fruit: .kiwi, num: UInt(sender.value))
        case mangoStepper:
            fruitStore.updateFruitStock(fruit: .mango, num: UInt(sender.value))
        default:
            break
        }
        
        configureUI()
    }
}
