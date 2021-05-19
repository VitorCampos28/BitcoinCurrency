//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by user194368 on 5/18/21.
//

import UIKit



// MARK: -Variabel and Constant
let key = "NWJiYmVmYTYzNjM2NDNlMWIwMThlZDUzYjRlYWZiNGY"
let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
//var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
var selectRow: Int = 0

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Outlets
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        fetchData(url: baseUrl)
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // retorno o numero de moedas para fazer a conversao.
        return curruncies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // retorna o titulo para a selacao
        selectRow = row
        return curruncies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fetchData(url: url)
    }
    func fetchData(url: String) {
        //fetch data from the url, using URLSession
        
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: "x-ba-key")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                self.parseJSON(json: data)
            } else {
                //Dados nao encontrados
                print("error")
            }
        }
        task.resume()
        
    }
    
    func parseJSON(json: Data) {
        do {
            
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    let askvalueString = valueFormatCurrency(value: askValue)
                    DispatchQueue.main.async {
                        self.price.text = curruncies[selectRow] + ": " + askvalueString}
                    print("success")} else {
                        print("error")
                    }
            }
        } catch {
            
            print("error parsing json: \(error)")
        }
    }
    func valueFormatCurrency(value: NSNumber) -> String{
        let format = NumberFormatter()
        format.numberStyle = .decimal
        format.groupingSeparator = "."
        format.decimalSeparator = ","
        return format.string(from: value) ?? String()
    }
    
    
}

