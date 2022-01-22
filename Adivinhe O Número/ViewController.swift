//
//  ViewController.swift
//  Adivinhe O Número
//
//  Created by Gil Carlos Volpato on 21/01/2022
//  as an exercise of the book Swift By Example, by Giordano Scalzo.
//  Copyright © 2022 Gil Carlos Volpato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var numberTxtField: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var numGuessesLbl: UILabel!
    private var lowerBound = 0
    private var upperBound = 100
    private var numGuesses = 0
    private var secretNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberTxtField.becomeFirstResponder()
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOkPressed(sender: AnyObject) {
        let number = Int(numberTxtField.text!)
        if let number = number {
            selectedNumber(number: number)
        } else {
            var alert = UIAlertController(title: nil, message: "Informe um número!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

private extension ViewController{
    enum Comparison{
        case Smaller
        case Greater
        case Equals
    }
    
    func selectedNumber(number: Int){
        //....
        switch compareNumber(number: number, otherNumber: secretNumber){
        case .Equals:
            var alert = UIAlertController(title: nil, message: "Você acertou em \(numGuesses) palpites!",
                preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { cmd in
                self.reset()
                self.numberTxtField.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
        case .Smaller:
            lowerBound = max(lowerBound, number)
            messageLbl.text = "Seu palpite foi muito baixo."
            numberTxtField.text = ""
            numGuesses = numGuesses + 1
            renderRange()
            renderNumGuesses()
        case .Greater:
            upperBound = min(upperBound, number)
            messageLbl.text = "Seu palpite foi muito alto."
            numberTxtField.text = ""
            numGuesses = numGuesses + 1
            renderRange()
            renderNumGuesses()
        }
    }
    
    func compareNumber(number: Int, otherNumber: Int) -> Comparison{
        if number < otherNumber {
            return .Smaller
        } else if number > otherNumber {
            return .Greater
        }
        
        return .Equals
    }
}

private extension ViewController{
    func extractSecretNumber() {
        let diff = upperBound - lowerBound
        let randomNumber = Int(arc4random_uniform(UInt32(diff)))
        secretNumber = randomNumber + Int(lowerBound)
    }
    
    func renderRange() {
        rangeLbl.text = "\(lowerBound) e \(upperBound)"
    }
    
    func renderNumGuesses() {
        numGuessesLbl.text = "Número de palpites feitos: \(numGuesses)"
    }
    
    func resetData() {
        lowerBound = 0
        upperBound = 100
        numGuesses = 0
    }
    
    func resetMsg() {
        messageLbl.text = ""
    }
    
    func reset(){
        resetData()
        renderRange()
        renderNumGuesses()
        extractSecretNumber()
        resetMsg()
    }
}
