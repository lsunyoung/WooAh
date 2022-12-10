//
//  PharmacyTableViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit
import Alamofire
import ProgressHUD

class PharmacyTableViewController: UITableViewController {
    var pharmacy:[Pharmacy] = []
    var page = 1
    
    // 선택된 퀵 메뉴 정보 - 일반 : "NONE", 방문가능 : "AVAL"
    var quickMenu:String?
    
    // 방문 가능 활성화/비활성화 여부
    var isAvalPharmacy = false
    
    // 심야약국 활성화/비활성화 여부
    var isMoonPharmacy = false
    
    var searchBar:UISearchBar?
    var longitude:Double?
    var latitude:Double?
    var isDistance = false
    
    @IBOutlet var possibleButton: UIButton!
    @IBOutlet var nightButton: UIButton!
    
    let baseURL = "https://wooahwooah.azurewebsites.net"
    //let baseURL = "http://192.168.219.105:3000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = 120
        self.title = "약국 목록"
        
        // 각종 상태 초기화
        iniMenuBtn();
        
        //퀵메뉴처리
        if quickMenu == "AVAL" {
            searchAval(with: searchBar?.text)
        } else {
            searchAddr(with: searchBar?.text)
        }
        
        possibleButton.layer.cornerRadius = 15
        nightButton.layer.cornerRadius = 15

    }
    
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //진료가능
    @IBAction func actpossibleBtn(_ sender: Any) {
        if isAvalPharmacy {
            // 메뉴 및 상태 초기화
            self.iniMenuBtn();
            
            searchAddr(with: self.searchBar!.text)
        } else {
            // 메뉴 및 상태 초기화
            self.iniMenuBtn();
            
            isAvalPharmacy = true
            self.possibleButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            searchAval(with: searchBar!.text)
        }
    }
    
    //심야약국
    @IBAction func actMoonPharmacy(_ sender: Any, forEvent event: UIEvent) {
        if isMoonPharmacy {
            // 메뉴 및 상태 초기화
            self.iniMenuBtn();
            
            searchAddr(with: self.searchBar!.text)
        } else {
            // 메뉴 및 상태 초기화
            self.iniMenuBtn();
            
            isMoonPharmacy = true
            self.nightButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            searchNight(with: searchBar?.text)
        }
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
            var request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                do{
                    let result = try JSONDecoder().decode(ResultData2.self, from: data)
                    self.pharmacy = result.pharmacy
                    
                    DispatchQueue.main.async {
                        if(self.pharmacy.count == 0) {
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
    
    //검색창 주소로 검색 시
    func searchAddr(with addr:String?) {
        
        var str = baseURL + "/pharmacy?page=0&limit=100"
        
        searchBase(with: addr, with2: str)
        
    }
    
    
    //방문가능
    func searchAval(with addr:String?) {

        DispatchQueue.main.async {
            self.isAvalPharmacy = true
            self.possibleButton.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        
        var str = baseURL + "/pharmacy?avalpharmacy=1&page=0&limit=100"
        
        searchBase(with: addr, with2: str)
    }
    
    //야간약국
    func searchNight(with addr:String?) {
        var str = baseURL + "/pharmacy?avalnight=1&page=0&limit=100"
        
        searchBase(with: addr, with2: str)
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
        
        // 거리정보
        if(isDistance) {
            cell.lblDistance.text = String(format: "%.0fm", pharmacyindex.distance)//"\(hospitalindex.distance) m"
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
          if pharmacyindex.dutyTime7s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime7c >= "\(formatter.string(from: date as Date))" {
                  cell.dateImage.isEnabled = true
              } else {
                  cell.dateImage.isEnabled = false
              }
          }
          break
        case 2 :
          if pharmacyindex.dutyTime1s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime1c >= "\(formatter.string(from: date as Date))" {
                  cell.dateImage.isEnabled = true
              } else {
                  cell.dateImage.isEnabled = false
              }
          }
          break
        case 3 :
          if pharmacyindex.dutyTime2s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime2c >= "\(formatter.string(from: date as Date))" {
                  cell.dateImage.isEnabled = true
              } else {
                  cell.dateImage.isEnabled = false
              }
          }
          break
          
        case 4 :
          if pharmacyindex.dutyTime3s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime3c >= "\(formatter.string(from: date as Date))" {
                  cell.dateImage.isEnabled = true
              } else {
                  cell.dateImage.isEnabled = false
              }
          }
          break
          
        case 5 :
          if pharmacyindex.dutyTime4s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime4c >= "\(formatter.string(from: date as Date))" {
                  cell.dateImage.isEnabled = true
              } else {
                  cell.dateImage.isEnabled = false
              }
          }
          break
          
        case 6 :
          if pharmacyindex.dutyTime5s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime5c >= "\(formatter.string(from: date as Date))" {
                  cell.dateImage.isEnabled = true
              } else {
                  cell.dateImage.isEnabled = false
              }
          }
          break
          
        case 7 :
          if pharmacyindex.dutyTime6s <= "\(formatter.string(from: date as Date))" {
              if pharmacyindex.dutyTime6c >= "\(formatter.string(from: date as Date))" {
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

        //
        //        if hospitalindex.dutyTime1s <= "\(formatter.string(from: date as Date))" {
        //            if hospitalindex.dutyTime1c >= "\(formatter.string(from: date as Date))" {
        //                cell.dateImage.isEnabled = true
        //            } else {
        //                cell.dateImage.isEnabled = false
        //            }
        //        }

        if pharmacyindex.dutyTime8s == "" {
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
            let pharmacy = self.pharmacy[indexPath.row]
            let call = pharmacy.dutyTel1
            if let url = NSURL(string: "tel://" + "\(call)"),
               UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                print("\(url)")
            }
        }
    }
    
    // 상단 메뉴 상태 초기화
    func iniMenuBtn() {
        isAvalPharmacy = false
        isMoonPharmacy = false
        possibleButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
        nightButton.backgroundColor = #colorLiteral(red: 0.9991703629, green: 0.9353709817, blue: 0.7279319167, alpha: 1)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let pharmacy = self.pharmacy[indexPath.row]
        let vc = segue.destination as? PharmacyDetailViewController
        vc?.pharmacy = pharmacy
    }

}
