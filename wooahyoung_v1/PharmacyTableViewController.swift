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
    var searchBar:UISearchBar?
    var longitude:Double?
    var latitude:Double?
    
    @IBOutlet var distanceButton: UIButton!
    @IBOutlet var possibleButton: UIButton!
    @IBOutlet var nightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        self.title = "약국 목록"
        if let searchBar = searchBar {
            search(with: searchBar.text)
        }
        if let searchBar = searchBar {
            if searchBar.text == "" {
                if let latitude = latitude {
                    if let longitude = longitude {
                        pharmacyMyLocation(mylat: latitude, mylon: longitude)
                    }
                }
            }
            search(with: searchBar.text)
            
        }
        
        distanceButton.layer.cornerRadius = 15
        possibleButton.layer.cornerRadius = 15
        nightButton.layer.cornerRadius = 15
    }
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func search(with addr:String?) {
        guard let addr = addr else {return}
        let url = "https://wooahwooah.azurewebsites.net/pharmacy?page=1&limit=30"
        print("url:",url)
        let params:Parameters = ["addr":addr]
        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)
        
        alamo.responseDecodable(of: ResultData2.self) { response in
            guard let root = response.value else {return}
            self.pharmacy = root.pharmacy
            print(self.pharmacy)
            self.tableView.reloadData()
        }
    }
    func pharmacyMyLocation(mylat:Double, mylon:Double) {
        let url = "https://wooahwooah.azurewebsites.net/pharmacy?page=1&limit=30"
        //        print("url:",url)
        let params:Parameters = ["mylon": mylon, "mylat": mylat]
        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)
        
        alamo.responseDecodable(of: ResultData2.self) { response in
            guard let root = response.value else {return}
            self.pharmacy = root.pharmacy
            //            print(self.hospital)
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
        cell.lblPharmacyCall.text = pharmacyindex.dutyTel1
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let pharmacy = self.pharmacy[indexPath.row]
        let vc = segue.destination as? PharmacyDetailViewController
        vc?.pharmacy = pharmacy
    }

}
