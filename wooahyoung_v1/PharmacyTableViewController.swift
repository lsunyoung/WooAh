//
//  PharmacyTableViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit
import Alamofire

class PharmacyTableViewController: UITableViewController {
    var pharmacy:[Pharmacy] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        self.title = "약국 목록"
        search(with: "", at: 1)
    }
    
    func search(with query:String?, at page:Int) {
        //        guard let query = query else {return} //옵셔널임 //http사이트일 경우 info에서 App Transport Security Settings 추가 -> 하위 Allow Arbitrary Loads 추가 -> Value를 Yes로 변경
        let url = "http://172.20.10.3:3000/pharmacy?page=1&limit=20" //구로디지털 원광대
        print("url:",url)
        //        let params:Parameters = ["query":query, "page": page]
        let alamo = AF.request(url, method: .get/*, parameters: params, headers: nil*/)
        
        alamo.responseDecodable(of: ResultData2.self) { response in
            guard let root = response.value else {return}
            self.pharmacy = root.pharmacy
            print(self.pharmacy)
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.pharmacy.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pharmacycell", for: indexPath) as? PharmacyCell else {fatalError()}
        let pharmacyindex = self.pharmacy[indexPath.row]
        cell.lblPharmacyName.text = pharmacyindex.dutyName
        cell.lblPharmacyAddr.text = pharmacyindex.dutyAddr
        cell.lblPharmacyCall.text = "Tel. \(pharmacyindex.dutyTel1)"
        //
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
