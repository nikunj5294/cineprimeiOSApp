//
//  DatePickerVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 20/07/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

protocol DatePickerVCDelegate {
    func dateDidSelect(timeStamp: Double)
}

class DatePickerVC: UIViewController {


    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: DatePickerVCDelegate?
    var maxDate: Double = Date().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.maximumDate = Date(timeIntervalSince1970: maxDate)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSelectAction(_ sender: UIButton) {
        
        self.delegate?.dateDidSelect(timeStamp: self.datePicker.date.timeIntervalSince1970)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

