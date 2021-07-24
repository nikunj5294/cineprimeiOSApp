//
//  TransactionVC.swift
//  V4 Stream
//
//  Created by Kishan Kasundra on 08/08/20.
//  Copyright © 2020 StarkTechnolabs. All rights reserved.
//

import UIKit

class TransactionVC: UIViewController {


    @IBOutlet weak var viewSubscription: UIView!
    @IBOutlet weak var viewRental: UIView!
    @IBOutlet weak var viewDonate: UIView!
    
    @IBOutlet weak var tblSubscription: UITableView!
    @IBOutlet weak var tblRental: UITableView!
    @IBOutlet weak var tblDonate: UITableView!

    @IBOutlet weak var cnstTblSubscriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstTblRentalHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstTblDonateHeight: NSLayoutConstraint!

    
    var transaction = Transaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageView()
        self.APIGetTransaction()
        
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func manageView() {
        
        self.cnstTblSubscriptionHeight.constant = CGFloat(self.transaction.subList.count * 235)
        self.cnstTblRentalHeight.constant = CGFloat(self.transaction.rentList.count * 235)
        self.cnstTblDonateHeight.constant = CGFloat(self.transaction.donateList.count * 235)
        
        self.viewSubscription.isHidden = (transaction.subList.count == 0)
        self.viewRental.isHidden = (transaction.rentList.count == 0)
        self.viewDonate.isHidden = (transaction.donateList.count == 0)
        
    }
}

extension TransactionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.tblSubscription:
            return transaction.subList.count
            
        case self.tblRental:
            return transaction.rentList.count
               
        default:
            return transaction.donateList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView {
        case self.tblSubscription:
            let cell: TransactionSubsCell = tableView.dequeueReusableCell(withIdentifier: "TransactionSubsCell", for: indexPath) as! TransactionSubsCell
            let temp = transaction.subList[indexPath.row]
            cell.lblPlanType.text = temp.transction_plan_name
            cell.lblPlanAmount.text = temp.transction_payment_amount
            cell.lblPaymentId.text = temp.transction_payment_id
            cell.lblSubscribedOn.text = temp.transction_date
            cell.lblExpiredOn.text = temp.transction_expiry_date
            return cell
            
        case self.tblRental:
            let cell: TransactionRentalCell = tableView.dequeueReusableCell(withIdentifier: "TransactionRentalCell", for: indexPath) as! TransactionRentalCell
            
            let temp = transaction.rentList[indexPath.row]
            
            cell.lblMovieName.text = temp.movie_name
            cell.lblRentalAmount.text = temp.transction_payment_amount
            cell.lblPaymentId.text = temp.transction_payment_id
            cell.lblSubscribedOn.text = temp.transction_date
            cell.lblExpiresOn.text = temp.expirty_date
            
            return cell
            
        default:
            let cell: TransactionDonatelCell = tableView.dequeueReusableCell(withIdentifier: "TransactionDonatelCell", for: indexPath) as! TransactionDonatelCell
            
            let temp = transaction.donateList[indexPath.row]
            cell.lblPlanType.text = temp.transction_plan_name
            cell.lblPlanAmount.text = temp.transction_payment_amount
            cell.lblPlanId.text = temp.transction_plan_id
            cell.lblSubscribedOn.text = temp.transction_date
            cell.lblExpiredOn.text = "-"
            
            return cell
        }
        
    }
    
    
}

extension TransactionVC {
    
    func APIGetTransaction() {
        let param : [String:Any] = ["user_id": kCurrentUser.user_id]
        
        AlamofireModel.alamofireMethod(.post, apiAction: .get_transaction_list, parameters: param, Header: header, handler: {res in
            
            let data = res.originalJSON["VIDEO_STREAMING_APP"]
            self.transaction.update(data)
            self.manageView()
            self.tblSubscription.reloadData()
            self.tblRental.reloadData()
            self.tblDonate.reloadData()
            
        }, errorhandler: {error in
            
        })
    }
}



