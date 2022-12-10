//
//  HospitalTableViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit
import Alamofire
import CoreLocation
import ProgressHUD
//import MapKit

class HospitalTableViewController: UITableViewController {
    
    let baseURL = "https://wooahwooah.azurewebsites.net"
    //let baseURL = "http://192.168.219.105:3000"
    
    var hospital:[Hospital] = []
    var page = 1
    
    var latitude:Double?
    var longitude:Double?
    var searchBar:UISearchBar?
    
    // 선택된 퀵 메뉴 정보 - 일반 : "NONE", 진료가능 : "AVAL"
    var quickMenu:String?
    
    // 진료 가능 활성화/비활성화 여부
    var isAvalHospital = false
    
    // 진료 과목 활성화/비활성화 여부
    var isMenuIDName = false
    
    // 진료 요일 활성화/비활성화 여부
    var isMenuDay = false
    
    // 거리 활성화/비활성화 여부
    var isDistance = false
    
    @IBOutlet var possibleButton: UIButton!
    @IBOutlet var idnameButton: UIButton!
    @IBOutlet var dayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        self.title = "병원 목록"

        // 각종 상태 초기화
        iniMenuBtn();
        
        //퀵메뉴처리
        if quickMenu == "AVAL" {
            searchAval(with: searchBar?.text)
        } else {
            searchAddr(with: searchBar?.text)
        }
        
        MenuIDName()
        MenuDay()
        possibleButton.layer.cornerRadius = 15
        idnameButton.layer.cornerRadius = 15
        dayButton.layer.cornerRadius = 15
    }
    
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //진료가능
    @IBAction func actpossibleBtn(_ sender: Any) {
        if isAvalHospital {
            // 메뉴 및 상태 초기화
            self.iniMenuBtn();
            
            searchAddr(with: self.searchBar!.text)
        } else {
            // 메뉴 및 상태 초기화
            self.iniMenuBtn();
            
            searchAval(with: searchBar!.text)
        }
    }
    
    //진료과목 메뉴
    func MenuIDName() {
        // 메뉴 및 상태 초기화
        iniMenuBtn();
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "전체", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9994406104, green: 0.93400383, blue: 0.7223937511, alpha: 1)
                    self.idnameButton.setTitle("진료과목", for: .normal)
                    self.searchAddr(with: self.searchBar?.text)
                    //self.performSegue(withIdentifier: "pharmacy", sender: (Any).self)
                }),
                UIAction(title: "내과", image: UIImage(named: "Internal1"), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("내과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                    self.searchHealth(with: self.searchBar!.text, with2: "내과")
                }),
                UIAction(title: "소아청소년과", image: UIImage(named: "Pediatric1"), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("소아청소년", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                    self.searchHealth(with: self.searchBar!.text, with2: "소아청소년")
                }),
                UIAction(title: "신경과", image: UIImage(named: "Neurology1"), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("신경과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                    self.searchHealth(with: self.searchBar!.text, with2: "신경과")
                }),
                UIAction(title: "이비인후과", image: UIImage(named: "Otolaryngology1"), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("이비인후과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                    self.searchHealth(with: self.searchBar!.text, with2: "이비인후과")
                }),
                UIAction(title: "정형외과", image: UIImage(named: "Orthopedics1"), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("정형외과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                    self.searchHealth(with: self.searchBar!.text, with2: "정형외과")
                }),
                UIAction(title: "외과", image: UIImage(named: "Surgical1"), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.idnameButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.idnameButton.setTitle("외과", for: .normal)
                    self.idnameButton.setTitleColor(.orange, for: .normal)
                    self.searchHealth(with: self.searchBar!.text, with2: "외과")
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(title: "진료과목 선택하세요.", image: nil, identifier: nil, options: [], children: menuItems)
        }
        idnameButton.menu = demoMenu
        idnameButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
    
    //진료요일
    func MenuDay() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "전체", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
                    self.dayButton.setTitle("진료요일", for: .normal)
                    self.searchAddr(with: self.searchBar!.text)
                }),
                UIAction(title: "월요일", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitle("월요일", for: .normal)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "1")
                }),
                UIAction(title: "화요일", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("화요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "2")
                }),
                UIAction(title: "수요일", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("수요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "3")
                }),
                UIAction(title: "목요일", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("목요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "4")
                }),
                UIAction(title: "금요일", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("금요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "5")
                }),
                UIAction(title: "토요일진료", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("토요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "6")
                }),
                UIAction(title: "일요일진료", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("일요일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchDay(with: self.searchBar!.text, with2: "0")
                }),
                UIAction(title: "공휴일진료", image: UIImage(systemName: ""), handler: { (_) in
                    // 메뉴 및 상태 초기화
                    self.iniMenuBtn();
                    self.dayButton.setTitle("공휴일", for: .normal)
                    self.dayButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                    self.dayButton.setTitleColor(.orange, for: .normal)
                    self.searchHoliday(with: self.searchBar!.text)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(title: "진료요일 선택하세요.", image: nil, identifier: nil, options: [], children: menuItems)
        }
        dayButton.menu = demoMenu
        dayButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
    
    // URL 기반 요청 공통
    func searchBase(with addr: String?, with2 searchURL : String) {
        
        ProgressHUD.show("검색중...")
        var str  = searchURL
        
        if let addr = addr {
            if addr == "" {
                if let latitude = latitude {
                    if let longitude = longitude {
                        isDistance = true
                        str += "&mylon=\(longitude)&mylat=\(latitude)"
                    }
                }
            } else {
                str += "&addr=\(addr)"
            }
        }
        
        if let strUrl = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strUrl){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                do{
                    let result = try JSONDecoder().decode(ResultData1.self, from: data)
                    self.hospital = result.hospital
                    
                    DispatchQueue.main.async {
                        if(self.hospital.count == 0) {
                            let alert = makeAlertWithOneAction(title: nil, message: "검색 결과가 없습니다.")
                            self.present(alert, animated: true)
                        }
                        
                        self.tableView.reloadData()
                    }
                }catch{
                    print("파싱 실패") //struct 타입 맞는지 확인해보기!!
                }
                
                ProgressHUD.dismiss()
            }.resume() //실행
        }
    }
    
    //검색창에 주소로 병원검색
    func searchAddr(with addr: String?) {
        
        let str = baseURL + "/hospital?page=0&limit=100"
        
        searchBase(with: addr, with2: str)
    }
    
    //진료가능 병원 검색
    func searchAval(with addr: String?) {

        DispatchQueue.main.async {
            self.isAvalHospital = true
            self.possibleButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        
        let str = baseURL + "/hospital?avalhospital=1&page=0&limit=100"
        
        searchBase(with: addr, with2: str)
    }
    
    // 진료과목 검색
    func searchHealth(with addr: String!, with2 health:String!) {
        guard let addr = addr else {return}
        
        let str = baseURL + "/hospital?page=0&limit=100&healthclinic="+health
        
        searchBase(with: addr, with2: str)
    }
    
    // 진료요일 검색
    func searchDay(with addr: String!, with2 avalday:String!) {
        guard let addr = addr else {return}
        
        let str = baseURL + "/hospital?page=0&limit=100&avalday="+avalday
        
        searchBase(with: addr, with2: str)
    }
    
    // 공휴일일 검색
    func searchHoliday(with addr: String?) {
        guard let addr = addr else {return}
        
        let str = baseURL + "/hospital?page=0&limit=100&avalholiday=1"
        
        searchBase(with: addr, with2: str)
    }
    
    
    // 상단 메뉴 상태 초기화
    func iniMenuBtn() {
        isAvalHospital = false
        isMenuIDName = false
        isMenuDay = false
        possibleButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
        idnameButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
        dayButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
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
        
        if(isDistance) {
            cell.lblDistance.text = String(format: "%.0fm", hospitalindex.distance)//"\(hospitalindex.distance) m"
        } else {
            cell.lblDistance.text = ""
        }
      
        //요일 정보
        let cal = Calendar(identifier:.gregorian)
        let now = Date()
        let comps = cal.dateComponents([.weekday], from:now)
        // 일요일 1, 월요일 2, 화요일 3, 수요일 4, 목요일 5, 금요일 6, 토요일 7
        print("요일 : \(comps.weekday!)")
        
        
        //시간 정보
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH00"
        
        switch comps.weekday {
        case 1 :
            if hospitalindex.dutyTime7s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime7c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
        case 2 :
            if hospitalindex.dutyTime1s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime1c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
        case 3 :
            if hospitalindex.dutyTime2s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime2c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
            
        case 4 :
            if hospitalindex.dutyTime3s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime3c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
            
        case 5 :
            if hospitalindex.dutyTime4s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime4c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
            
        case 6 :
            if hospitalindex.dutyTime5s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime5c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
            
        case 7 :
            if hospitalindex.dutyTime6s <= "\(formatter.string(from: date as Date))" {
                if hospitalindex.dutyTime6c >= "\(formatter.string(from: date as Date))" {
                    cell.dateImage.isEnabled = true
                } else {
                    cell.dateImage.isEnabled = false
                }
            }
            break
            
        case .none:
            cell.dateImage.isEnabled = false
            break
        case .some(_):
            cell.dateImage.isEnabled = false
            break
        }
        
        if hospitalindex.dutyTime8s == "" {
            cell.holiImage.isEnabled = false
        } else {
            cell.holiImage.isEnabled = true
        }
        
        return cell
    }
    
    //통화연결
    @IBAction func actCall(_ sender: Any) {
        let point = (sender as AnyObject).superview?.convert((sender as AnyObject).center, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: point!) {
            let hospital = self.hospital[indexPath.row]
            let call = hospital.dutyTel1
            if let url = NSURL(string: "tel://" + "\(call)"),
               UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                print("\(url)")
            }
        }
    }
        

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hospital" {
            let vc = segue.destination as? MapViewController
            vc?.hospital = hospital
        } else if  segue.identifier == "hospitaldetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let hospital = self.hospital[indexPath.row]
            let vc = segue.destination as? HospitalDetailViewController
            vc?.hospital = hospital
        }
    }
}
