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
    
    @IBOutlet var idnameButton: UIButton!
    @IBOutlet var dayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        self.title = "병원 목록"
        search(with: "", at: 1)
        
        MenuIDName()
        MenuDay()
    }
    func MenuIDName() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "내과", image: UIImage(named: "Internal1"), handler: { (_) in
                }),
                UIAction(title: "소아청소년과", image: UIImage(named: "Pediatric1"), handler: { (_) in
                }),
                UIAction(title: "신경과", image: UIImage(named: "Neurology1"), handler: { (_) in
                }),
                UIAction(title: "이비인후과", image: UIImage(named: "Otolaryngology1"), handler: { (_) in
                }),
                UIAction(title: "정형외과", image: UIImage(named: "Orthopedics1"), handler: { (_) in
                }),
                UIAction(title: "외과", image: UIImage(named: "Surgical1"), handler: { (_) in
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
                UIAction(title: "월요일", image: UIImage(systemName: ""), handler: { (_) in
                }),
                UIAction(title: "화요일", image: UIImage(systemName: ""), handler: { (_) in
                }),
                UIAction(title: "수요일", image: UIImage(systemName: ""), handler: { (_) in
                }),
                UIAction(title: "목요일", image: UIImage(systemName: ""), handler: { (_) in
                }),
                UIAction(title: "금요일", image: UIImage(systemName: ""), handler: { (_) in
                }),
                UIAction(title: "공휴일진료", image: UIImage(systemName: ""), handler: { (_) in
                }),
                UIAction(title: "야간진료", image: UIImage(systemName: ""), handler: { (_) in
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(title: "진료요일 선택하세요.", image: nil, identifier: nil, options: [], children: menuItems)
        }
        dayButton.menu = demoMenu
        dayButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
    
    func search(with query:String?, at page:Int) {
        //        guard let query = query else {return} //옵셔널임 //http사이트일 경우 info에서 App Transport Security Settings 추가 -> 하위 Allow Arbitrary Loads 추가 -> Value를 Yes로 변경
        let url = "http://172.20.10.3:3000/hospital?name=seoul&code=A&page=1&limit=20" //구로디지털 원광대
        
        print("url:",url)
        //        let params:Parameters = ["query":query, "page": page]
        let alamo = AF.request(url, method: .get/*, parameters: params, headers: nil*/)
        
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
        cell.lblHospitalCall.text = "Tel. \(hospitalindex.dutyTel1)"

        return cell
    }
    
//    @IBAction func actIDName(_ sender: UIButton) {
//        let id1 = UIAction(title: "내과", image: UIImage(named: "Internal1"), handler: { _ in
//        })
//        let id2 = UIAction(title: "소아청소년과", image: UIImage(named: "Pediatric1"), handler: { _ in
//        })
//        let id3 = UIAction(title: "신경과", image: UIImage(named: "Neurology1"), handler: { _ in
//        })
//        let id4 = UIAction(title: "이비인후과", image: UIImage(named: "Otolaryngology1"), handler: { _ in
//        })
//        let id5 = UIAction(title: "정형외과", image: UIImage(named: "Orthopedics1"), handler: { _ in
//        })
//        let id6 = UIAction(title: "외과", image: UIImage(named: "Surgical1"), handler: { _ in
//        })
//        sender.menu = UIMenu(title: "진료과목 선택하세요.",
//                                 children: [id1, id2, id3, id4, id5, id6])
//        sender.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
//    }
    
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
        let hospital = self.hospital[indexPath.row]
        let vc = segue.destination as? HospitalDetailViewController
        vc?.hospital = hospital
    }
    

}
