//
//  ViewController.swift
//  CurrencyConverterJSON
//
//  Created by Tatiana Looby on 22/02/2017.
//  Copyright © 2017 Tatiana Looby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
  
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var euroAmountTextField: UITextField!
    
    @IBOutlet weak var currencyTableView: UITableView!
    
    var imageArray = [#imageLiteral(resourceName: "british-flag-small.png"), #imageLiteral(resourceName: "american-flag-small.png"), #imageLiteral(resourceName: "russian-flag-small.png")]
    var ratesArray = [Double]()
    var amountToConvert = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyTableView.delegate =  self
        currencyTableView.dataSource = self
        
        euroAmountTextField.delegate = self
        
        getCurrencyData(urlString: "https://api.fixer.io/latest")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.flagImage.image = imageArray[indexPath.row]
         //When euroAmountTextField is empty, set currencyLabel to 0.00
        if euroAmountTextField.text == "" {
            cell.currencyLabel.text = "0.00"
            return cell
        }
        // Once the app is running, check that user entered an amount convertible to Double and if not, set currencyLabel to 0.00 and display a message to correct the entry
        if let euroAmount = Double(euroAmountTextField.text!) {
            amountToConvert = euroAmount
            cell.currencyLabel.text = String(format: "%.2f", amountToConvert*ratesArray[indexPath.row])
        } else {
            cell.currencyLabel.text = "0.00"
            euroAmountTextField.text = "Please enter amount in EUR"
            euroAmountTextField.textColor = UIColor.red
            
        }
        return cell
    }
    

    // Get url and call setCurrencyRates to get exchange rates from api.fixer/latest
    func getCurrencyData(urlString: String) {
        
        let url =  URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                self.setCurrencyRates(rates: data!)
            })
        }
        
        task.resume()
        
    }
    
    func setCurrencyRates(rates: Data) {
        
        do {
            let json = try JSONSerialization.jsonObject(with: rates, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
            if let date = json["date"] as? String {
                if let rate = json["rates"] as? Dictionary <String,AnyObject> {
                    if let gbp = rate["GBP"] as? Double, let usd = rate["USD"] as? Double, let rub = rate["RUB"] as? Double {
                        ratesArray.append(gbp)
                        ratesArray.append(usd)
                        ratesArray.append(rub)
                    }
                }
                dateLabel.textColor = UIColor.black
                dateLabel.text = date
            }
        } catch {
            print("Error fetching data")
        }
    }
    
    // Resign keyboard on return key and get table to reload to calculate converted amounts
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        euroAmountTextField.resignFirstResponder()
        currencyTableView.reloadData()

        return true
    }
    
}

