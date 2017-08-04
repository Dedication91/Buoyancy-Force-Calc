//
//  ViewController.swift
//  Buoyancy Force Calc
//
//  Created by Shaan Mirchandani on 8/4/17.
//  Copyright © 2017 Shaan Mirchandani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sgmSegmentedControl: UISegmentedControl!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    @IBOutlet weak var lblValue3: UILabel!
    @IBOutlet weak var btnResetButton: UIButton!
    @IBOutlet weak var lblFinalAnswer: UILabel!
    
    var unknownVariable: String = "Force"
    var value1 : Double?
    var value2 : Double?
    var value3 : Double?
    var finalAnswer : Double?
    var units : String = "N"
    var currentVarCount : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtInput.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        unknownVariable = sgmSegmentedControl.titleForSegment(at: sgmSegmentedControl.selectedSegmentIndex)!
        setLabels()
        lblFinalAnswer.text?.removeAll()
        txtInput.text?.removeAll()
        currentVarCount = 1
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        if (currentVarCount == 4) {
            calculateFinalAnswer()
            lblFinalAnswer.text = unknownVariable + " = " + String(format: "%.4f", finalAnswer!) + " " + units
            btnResetButton.setTitle("RESET!", for: UIControlState.normal)
            txtInput.isEnabled = false
        } else {
            lblFinalAnswer.text?.removeAll()
            txtInput.text?.removeAll()
            setLabels()
            txtInput.isEnabled = true
        }
        currentVarCount = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch currentVarCount {
        case 1:
            value1 = Double(txtInput.text!)!
            lblValue1.text! += String(value1!)
        case 2:
            value2 = Double(txtInput.text!)!
            lblValue2.text! += String(value2!)
        case 3:
            value3 = Double(txtInput.text!)!
            lblValue3.text! += String(value3!)
        default:
            break
        }
        currentVarCount += 1
        if (currentVarCount == 4){
            btnResetButton.setTitle("CALCULATE!", for: UIControlState.normal)
        }
        txtInput.text?.removeAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtInput.resignFirstResponder()
        txtInput.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (currentVarCount == 4){
            return false
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = NSCharacterSet(charactersIn: "1234567890.")
        if (string.isEmpty == true){
            return true
        }
        if let _ = string.rangeOfCharacter(from: allowedCharacters as CharacterSet){
            return true
        } else {
            return false
        }
    }
    
    func setLabels(){
        switch unknownVariable {
        case "Force":
            initializeLabels(var1: "Density", var2: "Gravity", var3: "Volume")
            units = "N"
        case "Density":
            initializeLabels(var1: "Force", var2: "Gravity", var3: "Volume")
            units = "Kg/m^3"
        case "Gravity":
            initializeLabels(var1: "Force", var2: "Density", var3: "Volume")
            units = "m/s^2"
        case "Volume":
            initializeLabels(var1: "Force", var2: "Density", var3: "Gravity")
            units = "m^3"
        default:
            break
        }
    }
    
    func initializeLabels(var1 : String, var2: String, var3: String){
        lblValue1.text = var1 + " = "
        lblValue2.text = var2 + " = "
        lblValue3.text = var3 + " = "
    }
    
    //fb = d*g*v
    //d = fb/(g*v)
    func calculateFinalAnswer(){
        switch unknownVariable {
        case "Force":
            let gxd = value1! * value2!
            finalAnswer = gxd * value3!
        case "Density", "Gravity", "Volume":
            finalAnswer = value1! / (value2! * value3!)
        default:
            break
        }
    }
    
}

