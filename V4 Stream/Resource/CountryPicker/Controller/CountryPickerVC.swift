//
//  CountryPickerVC.swift
//  ezRecorder
//
//  Created by Kishan Kasundra on 08/07/20.
//  Copyright © 2020 ezdi. All rights reserved.
//

import UIKit

protocol CountryPickerVCDelegate {
    func countryDidSelect(name : String, dial_code: String)
}

class CountryPickerVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var isDialCodeVisible : Bool = true
    var delegate: CountryPickerVCDelegate?
    var countryList : [CountryData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryList = country.list
        // Do any additional setup after loading the view.
    }
    
    @IBAction func txtSerachValueChanged(_ sender: UITextField)
    {
        
        let text = Utilities.trim(sender.text!)
        if text != "" {
            self.countryList = country.list.filter({$0.name.localizedCaseInsensitiveContains(text)})
        } else {
            self.countryList = country.list
        }
        self.tableview.reloadData()
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CountryPickerVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryPickerCell = tableView.dequeueReusableCell(withIdentifier: "CountryPickerCell", for: indexPath) as! CountryPickerCell
        
        let temp = self.countryList[indexPath.row]
        
        cell.lblName.text = temp.name
        cell.lblDialCode.text = temp.dial_code
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let temp = self.countryList[indexPath.row]
        
        self.delegate?.countryDidSelect(name: temp.name, dial_code: temp.dial_code)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
