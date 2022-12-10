//
//  HospitalDetailViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/22.
//

import UIKit
import MapKit
import CoreLocation

class HospitalDetailViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate{
    
    let fileName = "FavoriteHospitalList"
    var favoriteList:NSMutableArray?
    
    var hospital:Hospital?
    var locationManager = CLLocationManager() //좌표를 얻어오기 위한 변수
    
//    var latitude:Double?
//    var lo:Double?

    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    var mapPoint: MTMapPoint?
    var marker: MTMapPOIItem?
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddr: UILabel!
    @IBOutlet var lbltel1: UILabel!
    @IBOutlet var lbltel2: UILabel!
    @IBOutlet var lblID: UILabel!
    @IBOutlet var starButton: StarButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    
    @IBOutlet var dateButton: UIButton!{
        didSet {
            dateButton.isEnabled = false
        }
    }
    
    @IBOutlet var emergencyButton: UIButton!{
        didSet {
            emergencyButton.isEnabled = false
        }
    }
    
    
    @IBOutlet var bedButton: UIButton!{
        didSet {
            bedButton.isEnabled = false
        }
    }
    
    @IBOutlet var lblMon: UILabel!
    @IBOutlet var lblTue: UILabel!
    @IBOutlet var lblWed: UILabel!
    @IBOutlet var lblThu: UILabel!
    @IBOutlet var lblFri: UILabel!
    @IBOutlet var lblSat: UILabel!
    @IBOutlet var lblSun: UILabel!
    @IBOutlet var lblHoli: UILabel!
    
    @IBOutlet var kakaoButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var snsButton: UIButton!
    
    let scrollView: UIScrollView! = UIScrollView()
    let stackView: UIStackView! = UIStackView()
    @IBOutlet var detail: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            mapView.delegate = self // 델리게이트 연결
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
        
            if let hospital = hospital {
                lblName.text = hospital.dutyName
                lblAddr.text = hospital.dutyAddr
                lbltel1.text = hospital.dutyTel1
                lbltel2.text = hospital.dutyTel3
                lblID.text = hospital.dgidIdName
                lblMon.text = "월요일  \(hospital.dutyTime1s)-\(hospital.dutyTime1c)"
                lblTue.text = "화요일  \(hospital.dutyTime2s)-\(hospital.dutyTime2c)"
                lblWed.text = "수요일  \(hospital.dutyTime3s)-\(hospital.dutyTime3c)"
                lblThu.text = "목요일  \(hospital.dutyTime4s)-\(hospital.dutyTime4c)"
                lblFri.text = "금요일  \(hospital.dutyTime5s)-\(hospital.dutyTime5c)"
                lblSat.text = "토요일  \(hospital.dutyTime6s)-\(hospital.dutyTime6c)"
                lblSun.text = "일요일  \(hospital.dutyTime7s)-\(hospital.dutyTime7c)"
                lblHoli.text = "공휴일  \(hospital.dutyTime8s)-\(hospital.dutyTime8c)"
                
                // 좌표 찍기1
                mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: hospital.wgs84Lat, longitude: hospital.wgs84Lon)), zoomLevel: 1, animated: true)
                
//                // 좌표 찍기2
//                let geo = MTMapPointGeo(latitude: hospital.wgs84Lat, longitude: hospital.wgs84Lon)
//                let mapPoint = MTMapPoint(geoCoord: geo)
//                mapView.setMapCenter(mapPoint, zoomLevel: 1, animated: true)
                
                // 핀 찍기
                mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: hospital.wgs84Lat, longitude: hospital.wgs84Lon))
                marker = MTMapPOIItem()
                // 핀 디자인
//                poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
                marker?.markerType = .customImage
                marker?.customImage = UIImage(named: "hospital_marker_orange2")
                marker?.itemName = hospital.dutyName //이름
                marker?.showAnimationType = .noAnimation
                marker?.mapPoint = mapPoint
                mapView.add(marker)
                
                self.view.addSubview(mapView)
            }
        }
        
        locationManager.delegate = self
        if let hospital = hospital {
            if hospital.dutyEryn == 1 {
                self.emergencyButton.isEnabled = true
            } else {
                self.emergencyButton.isEnabled = false
            }
            if hospital.o038 == "" {
                self.bedButton.isEnabled = false
            } else {
                self.bedButton.isEnabled = true
            }
//            let date = NSDate()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH00"
//            if hospital.dutyTime1s <= "\(formatter.string(from: date as Date))" {
//                if hospital.dutyTime1c >= "\(formatter.string(from: date as Date))" {
//                    self.dateButton.isEnabled = true
//                } else {
//                    self.dateButton.isEnabled = false
//                }
//            }
            
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
                if hospital.dutyTime7s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime7c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
            case 2 :
                if hospital.dutyTime1s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime1c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
            case 3 :
                if hospital.dutyTime2s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime2c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
                
            case 4 :
                if hospital.dutyTime3s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime3c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
                
            case 5 :
                if hospital.dutyTime4s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime4c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
                
            case 6 :
                if hospital.dutyTime5s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime5c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
                
            case 7 :
                if hospital.dutyTime6s <= "\(formatter.string(from: date as Date))" {
                    if hospital.dutyTime6c >= "\(formatter.string(from: date as Date))" {
                        self.dateButton.isEnabled = true
                    } else {
                        self.dateButton.isEnabled = false
                    }
                }
                break
                
            case .none:
                self.dateButton.isEnabled = false
                break
            case .some(_):
                self.dateButton.isEnabled = false
                break
            }
        }
        
        // 즐겨찾기/starbutton
        let targetPath = getFilePath(fileName: fileName+".plist")
        guard let originPath = Bundle.main.path(forResource: fileName, ofType: "plist") else {return}
        copyFile(originPath,targetPath)
        guard let favoriteList = NSMutableArray(contentsOfFile: targetPath) else {return}
        self.favoriteList = favoriteList
        print("상세페이지 ", self.favoriteList)
        
        //즐겨찾기에 있는 병원일 경우 별 활성화
        if favoriteList.count > 0 {
            var overlap = false
            var overlapIndex = 0
            for (i, ele) in favoriteList.enumerated(){
                if let ele = ele as? [String:Any]  {
                    if ele["hpid"] as! String == hospital?.hpid {
                        print("이미 있다! : ",i)
                        print("이미 있다! : ",ele["hpid"] ,":",hospital?.hpid )
                        overlap = true
                        overlapIndex = i
                        break
                    }
                }
            }//for end
            self.starButton.isChecked = overlap
        }
    }

    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   //starButton
    @IBAction func starButton(_ sender: Any) {
        // starBtn Press Action
        guard let favoriteList = self.favoriteList else {fatalError()}
        let newDic = [
            "hpid" : hospital?.hpid,
            "dutyName" : hospital?.dutyName,
            "dutyAddr" : hospital?.dutyAddr,
            "dutyTel1" : hospital?.dutyTel1
        ] as [String : Any]
        
        if favoriteList.count > 0 {
            var overlap = false
            var overlapIndex = 0
            for (i, ele) in favoriteList.enumerated(){
                
                if let ele = ele as? [String:Any]  {
                    if ele["hpid"] as! String == hospital?.hpid {
                        print("이미 있다! : ",i)
                        print("이미 있다! : ",ele["hpid"] ,":",hospital?.hpid )
                        overlap = true
                        overlapIndex = i
                    }
                }
            }//for end
            if overlap {
                favoriteList.removeObject(at: overlapIndex)
                let filePath = getFilePath(fileName: fileName+".plist")
                let result =  favoriteList.write(toFile: filePath, atomically: true)
                if result {
                    //(sender as AnyObject).setImage(UIImage(systemName: "heart"), for: .normal)
                    self.starButton.isChecked = false
                    let alert =  makeAlertWithOneAction(title: nil, message: "삭제되었습니다.")
                    present(alert, animated: true)
                }else{
                    let alert = makeAlertWithOneAction(title: nil, message: "삭제 실패했습니다.")
                    present(alert, animated: true)
                }
            }else{
                favoriteList.add(newDic)
                let filePath = getFilePath(fileName: fileName+".plist")
                let result =  favoriteList.write(toFile: filePath, atomically: true)
                if result {
                    //(sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.starButton.isChecked = true
                    let alert = makeAlertWithOneAction(title: nil, message: "추가되었습니다.")
                    present(alert, animated: true)
                }else{
                    let alert = makeAlertWithOneAction(title: nil, message: "추가 실패했습니다.")
                    present(alert, animated: true)
                }
            }
        }else{
            print("없으니까 바로 실행!! ")
            
            favoriteList.add(newDic)
            let filePath = getFilePath(fileName: fileName+".plist")
            let result =  favoriteList.write(toFile: filePath, atomically: true)
            if result {
                //(sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.starButton.isChecked = true
                let alert = makeAlertWithOneAction(title: nil, message: "추가되었습니다.")
                present(alert, animated: true)
            }else{
                let alert = makeAlertWithOneAction(title: nil, message: "추가 실패했습니다.")
                present(alert, animated: true)
            }
        }
    }
    
    
    @IBAction func actShare(_ sender: Any) {
        let alert = UIAlertController(title: "공유", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        alert.addAction(action1)
        
        kakaoButton.frame = CGRect(x: 70, y: 60, width: 50, height: 50)
        alert.view.addSubview(kakaoButton)
        facebookButton.frame = CGRect(x: 160, y: 60, width: 50, height: 50)
        alert.view.addSubview(facebookButton)
        snsButton.frame = CGRect(x: 250, y: 60, width: 50, height: 50)
        alert.view.addSubview(snsButton)

        present(alert, animated: true)
    }
    @IBAction func actKakao(_ sender: Any) {
        // URLScheme 문자열을 통해 URL 인스턴스를 만들어 줍니다.
        if let url = NSURL(string: "kakaolink://"),
           //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
           UIApplication.shared.canOpenURL(url as URL) {
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actFacebook(_ sender: Any) {
        if let url = NSURL(string: "https://apps.apple.com/kr/app/facebook/id284882215"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actSns(_ sender: Any) {
        if let url = NSURL(string: "sms://"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func actCall(_ sender: Any) {
        guard let hospital = hospital else {return}
        let number = hospital.dutyTel1
        if let url = NSURL(string: "tel://" + "\(number)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actEmergencyCall(_ sender: Any) {
        guard let hospital = hospital else {return}
        let number = hospital.dutyTel3
        if let url = NSURL(string: "tel://" + "\(number)"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func actMap(_ sender: Any) {
        let alert = UIAlertController(title: "카카오맵", message: "카카오맵 길찾기 이동하시겠습니까?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "확인", style: .default) { _ in
            //스키마로 외부 앱 실행(info에 Queried URL Schemes 앱(kakaomap) 추가)
            // kakaomap://route?sp=37.4921839765254,127.03046988548856&ep=\(lat),\(lon)&by=CAR
            // kakaonavi://route?y=${“37.487491418638534”}&x=${“126.92906124401378”}&sX=${“\(lat)”}&sY=${“\(lon)”} //kakaonavi-sdk
            guard let hospital = self.hospital else {return}
            let lat:Double = hospital.wgs84Lat
            let lon:Double = hospital.wgs84Lon
            let mylat:Double = 37.4921839765254
            let mylon:Double = 127.03046988548856
            if let openApp = URL(string: "kakaomap://route?sp=\(mylat),\(mylon)&ep=\(lat),\(lon)&by=CAR"), UIApplication.shared.canOpenURL(openApp) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            } else {
                //앱 미설치시 앱스토어로 연결
                if let openStore = URL(string: "https://apps.apple.com/kr/app/%EC%B9%B4%EC%B9%B4%EC%98%A4%EB%A7%B5-%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD-no-1-%EC%A7%80%EB%8F%84%EC%95%B1/id304608425"), UIApplication.shared.canOpenURL(openStore) {
                    UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
                }
            }
        }
        let action2 = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true)
    }
    
    private func dateEnable() {
//        self.textField1.addAction(UIAction(handler: { _ in
//            if self.textField1.text?.isEmpty == true {
//                self.dutyErynImage.isEnabled = false
//            } else {
//                self.dutyErynImage.isEnabled = true
//            }
//        }), for: .editingChanged)
        
        
    
    }
    //즐겨찾기/starbutton
    override func viewWillAppear(_ animated: Bool) {
        let targetPath = getFilePath(fileName: fileName+".plist")
        //path는 무조건 optional
        guard let originPath = Bundle.main.path(forResource: fileName, ofType: "plist") else {return}
        copyFile(originPath,targetPath)
        
        guard let favoriteList = NSMutableArray(contentsOfFile: targetPath) else {return}
        self.favoriteList = favoriteList
        print("홈 reload", self.favoriteList)
        
//        print("aaa", UserDefaults.standard.string(forKey: "defaultText"))
//        defaultText = UserDefaults.standard.string(forKey: "defaultText") != nil ? UserDefaults.standard.string(forKey: "defaultText") : "아이유"
//        searchBar.text = defaultText
//        search(defaultText, page)
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
