//
//  BankAccountsVC.swift
//  Sun Fun
//
//  Created by arab devolpers on 8/6/19.
//  Copyright © 2019 arab devolpers. All rights reserved.
//

import UIKit
import SVProgressHUD
class BankAccountsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    var bankAccounts = [BankAccountModel]()
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        getAccounts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "BankCell", bundle: nil)
        
        
        tableView.register(nib, forCellReuseIdentifier: "BankCell")
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230.0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankCell",for: indexPath) as! BankCell
        let pos = indexPath.row
        if bankAccounts.count > 0 {
        let item = bankAccounts[pos]
        
        cell.accountName.text = item.account_name!
        cell.accountBankName.text = item.account_bank_name!
        cell.accountIBAN.text = item.account_IBAN!
        cell.accountNumber.text = item.account_number!
        }
        return cell
    }
    
    func getAccounts(){
        SVProgressHUD.show()
        More_API().bankAccount { (success:Bool, result:[BankAccountModel]?) in
            SVProgressHUD.dismiss()
            if success{
                if result != nil{
                    
                    self.bankAccounts.append(contentsOf: result!)
                    self.tableView.reloadData()
                    
                }
            }else{
                
            }
        }
    }
}
