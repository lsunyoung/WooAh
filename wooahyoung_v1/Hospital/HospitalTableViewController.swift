//
//  HospitalTableViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit
import Alamofire

class HospitalTableViewController: UITableViewController {
    
    var hospital:[Hospital] = []
    var page = 1
    
    var la:Double?
    var lo:Double?
    var searchtext:UISearchBar?
    
    @IBOutlet var distanceButton: UIButton!
    @IBOutlet var possibleButton: UIButton!
    @IBOutlet var idnameButton: UIButton!
    @IBOutlet var dayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        self.title = "병원 목록"
        if let searchtext = searchtext {
            search(with: searchtext)
        }
        
        MenuIDName()
        MenuDay()
        distanceButton.layer.cornerRadius = 15
        possibleButton.layer.cornerRadius = 15
        idnameButton.layer.cornerRadius = 15
        dayButton.layer.cornerRadius = 15
    }
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func MenuIDName() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "진료과목", image: UIImage(systemName: ""), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9994406104, green: 0.93400383, blue: 0.7223937511, alpha: 1)
                    self.idnameButton.setTitle("진료과목", for: .normal)
                }),
                UIAction(title: "내과", image: UIImage(named: "Internal1"), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("내과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "소아청소년과", image: UIImage(named: "Pediatric1"), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("소아청소년", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "신경과", image: UIImage(named: "Neurology1"), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("신경과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "이비인후과", image: UIImage(named: "Otolaryngology1"), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("이비인후과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "정형외과", image: UIImage(named: "Orthopedics1"), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("정형외과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "외과", image: UIImage(named: "Surgical1"), handler: { (_) in
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("외과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(title: "진료과목 선택하세요.", image: nil, identifier: nil, options: [], children: menuItems)
        }
        idnameButton.menu = demoMenu
        idnameButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
    func MenuDay() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "진료요일", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
                    self.dayButton.setTitle("진료요일", for: .normal)
                }),
                UIAction(title: "월요일", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitle("월요일", for: .normal)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "화요일", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.setTitle("화요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "수요일", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.setTitle("수요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "목요일", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.setTitle("목요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "금요일", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.setTitle("금요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "공휴일진료", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.setTitle("공휴일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                }),
                UIAction(title: "야간진료", image: UIImage(systemName: ""), handler: { (_) in
                    self.dayButton.setTitle("야간", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(title: "진료요일 선택하세요.", image: nil, identifier: nil, options: [], children: menuItems)
        }
        dayButton.menu = demoMenu
        dayButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
    
    func search(with addr: String?) {
        guard let addr = addr else {return}
//        let url = "http://172.20.10.3:3000/hospital?name=seoul&code=A&page=1&limit=20"
        let url = "https://wooahwooah.azurewebsites.net/hospital?page=1&limit=30"
        
        print("url:",url)
        let params:Parameters = ["addr": addr]
        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)
        
        alamo.responseDecodable(of: ResultData1.self) { response in
            guard let root = response.value else {return}
            self.hospital = root.hospital
            print(self.hospital)
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
        return self.hospital.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hospitalcell", for: indexPath) as? HospitalCell else {fatalError()}
        let hospitalindex = self.hospital[indexPath.row]
        cell.lblHospitalName.text = hospitalindex.dutyName
        cell.lblHospitalAddr.text = hospitalindex.dutyAddr
        cell.lblHospitalCall.text = hospitalindex.dutyTel1

        return cell
    }

    @IBAction func actCall(_ sender: Any) {
        let point = (sender as AnyObject).superview?.convert((sender as AnyObject).center, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point!) {
            let hospitals = self.hospital[indexPath.row]
            let call = hospitals.dutyTel1
            if let url = NSURL(string: "tel://" + "\(call)"),
               UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                print("\(url)")
            }
        }
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
        if segue.identifier == "hospital" {
//            let vc = segue.destination as? MapViewController
//            vc?.hospitals = hospital
        } else if  segue.identifier == "hospitaldetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let hospital = self.hospital[indexPath.row]
            let vc = segue.destination as? HospitalDetailViewController
            vc?.hospital = hospital
            guard let la = la else {return}
            vc?.la = la
            guard let lo = lo else {return}
            vc?.lo = lo
        }
    }
    

}
