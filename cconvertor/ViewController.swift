//
//  ViewController.swift
//  cconvertor
//
//  Created by apple on 08/08/17.
//  Copyright © 2017 Falconnect Technologies Private Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Balance Declaration
    @IBOutlet weak var usdBalance: UILabel!
    @IBOutlet weak var eurBalance: UILabel!
    @IBOutlet weak var jpyBalance: UILabel!
    
    @IBOutlet weak var success: UILabel!
    @IBOutlet weak var servicecharge: UILabel!
    
    //Image Declaration
    @IBOutlet weak var fromFlagImage: UIImageView!
    @IBOutlet weak var toFlagImage: UIImageView!
    
    //Currency Declaration
    @IBOutlet weak var fromCurrencyImage: UIImageView!
    @IBOutlet weak var toCurrencyImage: UIImageView!

    //Button Declaration
    @IBOutlet weak var convert: UIButton!
    
    //Currency Button
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    
    //Value Declaration
    @IBOutlet weak var fromValue: UITextField!
    @IBOutlet weak var toValue: UITextField!
    
    //Key values
    var fromKey : String?
    var toamount: String?
    var amountKey : String?
    
    //Response
    var currencyName: String!
    var currencyAmount : Double!
    var currencyAmountString : String!
    var taxCalcs : Double!
    
    var countValue : Int!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //Button background
        convert.backgroundColor = .clear
        convert.layer.cornerRadius = 5
        convert.layer.borderWidth = 1
        convert.layer.borderColor = UIColor.white.cgColor
        
        //toValue UserInteraction
        toValue.isUserInteractionEnabled = false
        
        //Inital amount
        usdBalance.text = "1000.00"
        eurBalance.text = "0.00"
        jpyBalance.text = "0.00"
        countValue = 0
        taxCalcs = 0
        
        // ToolBar for keyboard
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.lightGray
        toolBar.sizeToFit()
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        fromValue.inputAccessoryView = toolBar
    }


    //Done action
    func doneClick() {
        fromValue.resignFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //From Currency
    @IBAction func fromCurrency() {
        let alertController = UIAlertController(title: "Currency Converter", message: "Convert your currency at your choice", preferredStyle: .actionSheet)
        
        let EUR = UIAlertAction(title: "EUR", style: .default, handler: {
            action in
            if self.eurBalance.text == "0.00"{
                self.alert()
            }else{
                self.fromCurrencyButton?.setTitle("EUR", for:.normal)
                self.fromCurrencyImage.image = UIImage(named: "euro")
                self.fromFlagImage.image = UIImage(named: "euroflag")
            }
        })
        alertController.addAction(EUR)
        
        let USD = UIAlertAction(title: "USD", style: .default, handler: {
            action in
            if self.usdBalance.text == "0.00"{
                self.alert()
            }else{
            self.fromCurrencyButton?.setTitle("USD", for: .normal)
            self.fromCurrencyImage.image = UIImage(named: "dollor")
            self.fromFlagImage.image = UIImage(named: "usd")
            }
        })
        alertController.addAction(USD)
        
        let JPY = UIAlertAction(title: "JPY", style: .default, handler: {
            action in
            if self.jpyBalance.text == "0.00"{
                self.alert()
            }else{
            self.fromCurrencyButton?.setTitle("JPY", for: .normal)
            self.fromCurrencyImage.image = UIImage(named: "japan")
            self.fromFlagImage.image = UIImage(named: "jpy")
            }
        })
        alertController.addAction(JPY)
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    //To Currency
    @IBAction func toCurrency() {
        let alertController = UIAlertController(title: "Currency Converter", message: "Convert your currency at your choice", preferredStyle: .actionSheet)
        
        let EUR = UIAlertAction(title: "EUR", style: .default, handler: {
            action in
            self.toCurrencyButton?.setTitle("EUR", for:.normal)
            self.toCurrencyImage.image = UIImage(named: "euro")
            self.toFlagImage.image = UIImage(named: "euroflag")
        })
        alertController.addAction(EUR)
        
        let USD = UIAlertAction(title: "USD", style: .default, handler: {
            action in
            self.toCurrencyButton?.setTitle("USD", for: .normal)
            self.toCurrencyImage.image = UIImage(named: "dollor")
            self.toFlagImage.image = UIImage(named: "usd")
        })
        alertController.addAction(USD)
        
        let JPY = UIAlertAction(title: "JPY", style: .default, handler: {
            action in
            self.toCurrencyButton?.setTitle("JPY", for: .normal)
            self.toCurrencyImage.image = UIImage(named: "japan")
            self.toFlagImage.image = UIImage(named: "jpy")
        })
        alertController.addAction(JPY)
        
        let defaultAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    //API Calling Function
    @IBAction func callMethod(){
        if fromCurrencyButton.title(for: .normal) == toCurrencyButton.title(for: .normal) || fromValue.text == toValue.text
        {
            let alert = UIAlertController(title: "Same currency", message: "You are not allowed to transfer to the same account", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.methods()
        }
    }
    
    //Amount valuation
    func methods()
    {
        if self.fromCurrencyButton.title(for: .normal)! == "USD" {
            if self.fromValue.text! < self.usdBalance.text!{
                self.apiFunction()
            }else{
                self.alert()
            }
        }else if self.fromCurrencyButton.title(for: .normal)! == "EUR"{
            if self.fromValue.text! < self.eurBalance.text!{
                self.apiFunction()
            }else{
                self.alert()
            }
        }else if self.fromCurrencyButton.title(for: .normal)! == "JPY"{
            if self.fromValue.text! < self.jpyBalance.text!{
                self.apiFunction()
            }else{
                self.alert()
            }
        }
    }
    //Alert Function
    func alert()  {
        let alert = UIAlertController(title: "Insufficent Balance", message: "Your balance is insufficent to make this transaction", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    //Tax Calculation
    func taxCalculation() {
            self.taxCalcs = Double(self.amountKey!)! * 0.7 / 100
    }
    
    
    //Web service
    func apiFunction()  {
        self.fromKey = fromCurrencyButton.title(for: .normal)!
        self.toamount = toCurrencyButton.title(for: .normal)!
        self.amountKey = fromValue.text!
        
        let url = URL(string: "http://api.evp.lt/currency/commercial/exchange/\(amountKey!)-\(fromKey!)/\(toamount!)/latest")
        print(url!)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    print(json)
                    OperationQueue.main.addOperation({
                        self.countValue = self.countValue + 1
                        if self.countValue > 5{
                            self.taxCalculation()
                            print("entry")
                        }
                        self.currencyName = json["currency"] as! String
                        self.currencyAmountString = json["amount"] as! String
                        self.toValue.text = self.currencyAmountString

                        switch self.currencyName {
                        case "USD":
                            self.currencyAmount = Double(self.usdBalance.text!)! + Double(self.currencyAmountString)!
                            self.usdBalance.text = String(format:"%.2f", self.currencyAmount)
                            
                            if self.fromCurrencyButton.title(for: .normal)! == "EUR" {
                                self.eurBalance.text = String(format:"%.2f", (Double(self.eurBalance.text!)! - Double(self.amountKey!)!) - Double(self.taxCalcs))
                            }else if self.fromCurrencyButton.title(for: .normal)! == "JPY"{
                                self.jpyBalance.text = String(format:"%.2f", (Double(self.jpyBalance.text!)! - Double(self.amountKey!)!) - Double(self.taxCalcs))
                            }

                            break
                        case "EUR":
                            self.currencyAmount = Double(self.eurBalance.text!)! + Double(self.currencyAmountString)!
                            self.eurBalance.text = String(format:"%.2f", self.currencyAmount)
                            
                            if self.fromCurrencyButton.title(for: .normal)! == "USD"{
                                self.usdBalance.text = String(format:"%.2f", (Double(self.usdBalance.text!)! - Double(self.amountKey!)!) - Double(self.taxCalcs))
                            }else if self.fromCurrencyButton.title(for: .normal)! == "JPY"{
                                self.jpyBalance.text = String(format:"%.2f", (Double(self.jpyBalance.text!)! - Double(self.amountKey!)!) - Double(self.taxCalcs))
                            }

                            break
                        case "JPY":
                            self.currencyAmount = Double(self.eurBalance.text!)! + Double(self.currencyAmountString)!
                            self.jpyBalance.text = String(format:"%.2f", self.currencyAmount)
                            
                            if self.fromCurrencyButton.title(for: .normal)! == "EUR"{
                                self.eurBalance.text = String(format:"%.2f", (Double(self.eurBalance.text!)! - Double(self.amountKey!)!) - Double(self.taxCalcs))
                            }else if self.fromCurrencyButton.title(for: .normal)! == "USD"{
                                self.usdBalance.text = String(format:"%.2f", (Double(self.usdBalance.text!)! - Double(self.amountKey!)!) - Double(self.taxCalcs))
                            }

                            break
                        default: break
                        }
                        
                        self.success.text = String(format:"You have converted \(self.fromValue.text!) \(self.fromCurrencyButton.title(for: .normal)!) to \(String(format:"%.2f",self.currencyAmount)) \(self.toCurrencyButton.title(for: .normal)!). Commission Fee - \(String(format:"%.2f",self.taxCalcs)) \(self.fromCurrencyButton.title(for: .normal)!) ")
                        
                        self.fromValue.text = ""
                        
                        print(self.success.text!)
                        
                    })
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()

    }
    
    //Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true;
    }

}

