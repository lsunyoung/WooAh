//
//  MapViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit
import MapKit
import CoreLocation
//import Alamofire
import SafariServices
import ProgressHUD

class MapViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    
    let baseURL = "https://wooahwooah.azurewebsites.net"
    //let baseURL = "http://192.168.219.105:3000"
    
    var fileName:String = ""
    var favoriteList:NSMutableArray?
   
    var query:String = ""
    var hospital:[Hospital] = []
    var pharmacy:[Pharmacy] = []
    var page = 1
    
    // 선택된 퀵 메뉴 정보 - 일반 : "NONE", 진료가능 or 방문가능 : "AVAL"
    var quickMenu = "NONE"
    
    // 내위치 기반 검색 여부
    var isSearchLocation = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var MenuButton: UIButton!
    @IBOutlet var MyLocationBtn: UIButton!
    @IBOutlet var HospitalBtn: UIButton!
    @IBOutlet var PharmacyBtn: UIButton!
    @IBOutlet var FavoritesBtn: UIButton!
    
    @IBOutlet var mainButton: UIStackView!
    
    var mapPoint: MTMapPoint?
    var marker: MTMapPOIItem?
    
    var mapPoint1: MTMapPoint?
    var marker1: MTMapPOIItem?
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
//    var latitude : Double = 37.53737528
//    var longitude : Double = 127.00557633
    
    var allCircle = [MTMapCircle]()
    
    var locationManager = CLLocationManager() //좌표를 얻어오기 위한 변수
    var latitude:Double!
    var longitude:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hospitalSearch(with:"여의도")
//        pharmacySearch(with:"여의도")
        
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            mapView.delegate = self // 델리게이트 연결
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            self.view.addSubview(mapView)
        }
        // bringSubviewToFront view맨앞으로
        self.view.bringSubviewToFront(MyLocationBtn)
        self.view.bringSubviewToFront(HospitalBtn)
        self.view.bringSubviewToFront(PharmacyBtn)
        self.view.bringSubviewToFront(FavoritesBtn)
        self.view.bringSubviewToFront(mainButton)
        self.view.bringSubviewToFront(searchBar)
        self.view.bringSubviewToFront(MenuButton)
        
        Menu()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //거리 정확도 설정
        locationManager.requestWhenInUseAuthorization() // 위치 팝업
        locationManager.startUpdatingLocation() //위치 계속 가져옴
        
        MyLocationBtn.layer.cornerRadius = 15 //버튼 라운드 처리
    }
    
    // 병원목록 버튼 클릭 시
    @IBAction func actHospitalList(_ sender: Any) {
        // 퀵 메뉴 선택 이동 아님 처리
        self.quickMenu = "NONE"
    }
    
   // 약국목록 버튼 클릭시
    @IBAction func actPharmacyList(_ sender: Any) {
        // 퀵 메뉴 선택 이동 아님 처리
        self.quickMenu = "NONE"
    }
    
    
    // 메뉴 생성
    func Menu() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "즐겨찾기", image: UIImage(named: "Star"), handler: { (_) in
                    self.performSegue(withIdentifier: "menu_favorite", sender: (Any).self)
                    
                }),
                UIAction(title: "현재 진료가능 병원", image: UIImage(named: "hospital"), handler: { [self] (_) in
                    
                    if isSearchLocation || searchBar.text != "" {
                        self.quickMenu = "AVAL"
                        self.performSegue(withIdentifier: "hospital", sender: (Any).self)
                    } else {
                        let alert = UIAlertController(title: "", message: "주소검색 또는 내 주변찾기로 검색 후 이용해주세요", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(action)
                        present(alert, animated: true)
                    }
        
                }),
                
                UIAction(title: "현재 방문가능 약국", image: UIImage(named: "pharmacy"), handler: { [self] (_) in
                    if isSearchLocation || searchBar.text != "" {
                        self.quickMenu = "AVAL"
                        self.performSegue(withIdentifier: "pharmacy", sender: (Any).self)
                    } else {
                        let alert = UIAlertController(title: "", message: "주소검색 또는 내 주변찾기로 검색 후 이용해주세요", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(action)
                        present(alert, animated: true)
                    }
    
                }),
                UIAction(title: "달빛어린이 병원", image: UIImage(named: "moonhospital"), handler: { (_) in
                    let moonUrl = NSURL(string: "https://www.e-gen.or.kr/moonlight/")
                    let moonSafariView: SFSafariViewController = SFSafariViewController(url: moonUrl! as URL)
                    self.present(moonSafariView, animated: true, completion: nil)
                }),
                UIAction(title: "심야 약국", image: UIImage(named: "moonpharmacy"), handler: { (_) in
                    self.performSegue(withIdentifier: "pharmacy", sender: (Any).self)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        }
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu", image: nil, primaryAction: nil, menu: demoMenu) // item bar button 생성
        
        MenuButton.menu = demoMenu
        MenuButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
    
    //검색창 주소로 병원검색
    func hospitalSearch(with addr:String?) {
        guard let addr = addr else {return}
        
        let str = baseURL + "/hospital?page=0&limit=100&addr=\(addr)"
        if let strUrl = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strUrl){
            var request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                do{
                    let result = try JSONDecoder().decode(ResultData1.self, from: data)
                    self.hospital = result.hospital
                    DispatchQueue.main.async {
                        self.mapPOIhospital()
                    }
                }catch{
                    print("파싱 실패")
                }
                ProgressHUD.dismiss()
            }.resume() //실행
        }
    }
    
    //내위치기반 병원 검색
    func hospitalMyLocation(mylat:Double, mylon:Double) {
        let str = baseURL + "/hospital?page=0&limit=100&mylon=\(mylon)&mylat=\(mylat)"
        if let strUrl = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strUrl){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                do{
                    let result = try JSONDecoder().decode(ResultData1.self, from: data)
                    self.hospital = result.hospital
                    DispatchQueue.main.async {
                        self.mapPOIhospital()
                    }
                }catch{
                    print("파싱 실패") 
                }
                
                ProgressHUD.dismiss()
            }.resume() //실행
        }
        
//        let url = "https://wooahwooah.azurewebsites.net/hospital?page=0&limit=30"
////        print("url:",url)
//        let params:Parameters = ["mylon": mylon, "mylat": mylat]
//        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)
//
//        alamo.responseDecodable(of: ResultData1.self) { response in
////            print(response)
//            guard let root = response.value else {return}
//            self.hospital = root.hospital
//            //            print(self.hospital)
//            self.mapPOIhospital()
//        }
    }
    
    //병원검색 결과 마커 표시
    func mapPOIhospital() {
        if let mapView = self.mapView {
            var items:[MTMapPOIItem] = [] //POI array
            for arraylist in self.hospital {
                let item = MTMapPOIItem()
                item.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: arraylist.wgs84Lat, longitude: arraylist.wgs84Lon)) // 경도 위도
                item.itemName = arraylist.dutyName // 마커 선택 시 이름
                item.markerType = .customImage // 마커 타입 커스텀
                item.customImage = UIImage(named: "hospital_marker_orange2") // 마커 커스텀 이미지
                item.showAnimationType = .noAnimation // 애니메이션 무
                items.append(item) //추가
                print("TEST1 - \(item)")
            }
           
            mapView.addPOIItems(items)
            
            guard let hospital = self.hospital.first else {return} // 첫번째
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  hospital.wgs84Lat, longitude: hospital.wgs84Lon)), zoomLevel: 2, animated: true) // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등을 설정)
        }
    }
    
    //검색창 주소로 약국검색
    func pharmacySearch(with addr:String?) {
        guard let addr = addr else {return}
        let str = baseURL + "/pharmacy?page=0&limit=100&addr=\(addr)"
        if let strUrl = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strUrl){
            var request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                do{
                    let result = try JSONDecoder().decode(ResultData2.self, from: data)
                    self.pharmacy = result.pharmacy
                    DispatchQueue.main.async {
                        self.mapPOIpharmacy()
                    }
                }catch{
                    print("파싱 실패") //struct 타입 맞는지 확인해보기!!
                }
            }.resume() //실행
        }
        
//        let url = "https://wooahwooah.azurewebsites.net/pharmacy?page=0&limit=30"
////        print("url:",url)
//        let params:Parameters = ["addr": addr]
//        let alamo = AF.request(url, method: .get, parameters: params, encoding: URLEncoding.queryString)
//
//        alamo.responseDecodable(of: ResultData2.self) { response in
//            print(response)
//            guard let root = response.value else {return}
//            self.pharmacy = root.pharmacy
////            print(self.hospital)
//            self.mapPOIpharmacy()
//        }
    }
    
    //내위치 기반 약국검색
    func pharmacyMyLocation(mylat:Double, mylon:Double) {
        let str = baseURL + "/pharmacy?page=0&limit=100&mylon=\(mylon)&mylat=\(mylat)"
        if let strUrl = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strUrl){
            var request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                do{
                    let result = try JSONDecoder().decode(ResultData2.self, from: data)
                    self.pharmacy = result.pharmacy
                    DispatchQueue.main.async {
                        self.mapPOIpharmacy()
                    }
                }catch{
                    print("파싱 실패") //struct 타입 맞는지 확인해보기!!
                }
            }.resume() //실행
        }
        
//        let url = "https://wooahwooah.azurewebsites.net/pharmacy?page=0&limit=30"
////        print("url:",url)
//        let params:Parameters = ["mylon": mylon, "mylat": mylat]
//        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)
//
//        alamo.responseDecodable(of: ResultData2.self) { response in
//            guard let root = response.value else {return}
//            self.pharmacy = root.pharmacy
////            print(self.hospital)
//            self.mapPOIpharmacy()
//        }
    }
    
    //약국 검색결과 마커표시
    func mapPOIpharmacy() {
        if let mapView = self.mapView {
            var items:[MTMapPOIItem] = []
            for arraylist in self.pharmacy {
                let item = MTMapPOIItem()
                item.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: arraylist.wgs84Lat, longitude: arraylist.wgs84Lon))
                item.itemName = arraylist.dutyName
                item.markerType = .customImage
                item.customImage = UIImage(named: "pharmacy_marker_green2")
                item.showAnimationType = .noAnimation
                items.append(item)
                print("TEST2 - \(item)")
            }
            mapView.addPOIItems(items)
        }
    }
    
    //위치정보 계속 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 내 위치 기반 검색여부 확인
        //if !isSearchLocation {return}
        
        if let location = locations.first { // 위치 정보 계속 업데이트
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    @IBAction func actMyLocation(_ sender: Any) {
        
        ProgressHUD.show("검색중...")
        //ProgressHUD.dismiss()
        
        self.view.endEditing(true)
        
        isSearchLocation = true
        searchBar.text = ""
        if let mapView = mapView {
            mapView.removeAllPOIItems() // poiitems 지워짐
        }
        
        // 현재 위치 트래킹
        mapView?.currentLocationTrackingMode = .onWithoutHeading
        mapView?.showCurrentLocationMarker = true
        if let latitude = latitude {
            if let longitude = longitude {
                hospitalMyLocation(mylat: latitude, mylon: longitude)
                pharmacyMyLocation(mylat: latitude, mylon: longitude)
            }
        }
       
    }

    // 다른 영역 클릭 시 키보드 미노출 처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // 뷰 이동을 위한 데이터 처리
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hospital" {
            let vc = segue.destination as? HospitalTableViewController
            vc?.latitude = latitude
            vc?.longitude = longitude
            vc?.searchBar = searchBar
            vc?.quickMenu = quickMenu
        } else if  segue.identifier == "pharmacy" {
            let vc = segue.destination as? PharmacyTableViewController
            vc?.searchBar = searchBar
            vc?.latitude = latitude
            vc?.longitude = longitude
            vc?.quickMenu = quickMenu
        } else if segue.identifier == "menu_favorite" {
            let vc = segue.destination as? FavoriteTableViewController
            vc?.favoriteList = favoriteList
        }
    }
    
    // 뷰 이동전 처리
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if isSearchLocation || searchBar.text != "" {
            return true
        }
        
        let alert = UIAlertController(title: "", message: "주소검색 또는 내 주변찾기로 검색 후 이용해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
        
        return false
    }
}


extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ProgressHUD.show("검색중...")
        //ProgressHUD.dismiss()
        
        // 내 위치기준 검색 여부 설정
        isSearchLocation = false
        
        if let mapView = mapView {
            mapView.removeAllPOIItems() // poiitems 지워짐
        }
        
        if searchBar.text == "" || searchBar.text == nil {
            let alert = UIAlertController(title: "", message: "검색어를 입력해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }else{
            let searchtext = searchBar.text
            hospitalSearch(with:searchtext)
            pharmacySearch(with:searchtext)
            searchBar.resignFirstResponder() //키보드내림
        }
        
//        let searchtext = searchBar.text
//        hospitalSearch(with:searchtext)
//        pharmacySearch(with:searchtext)
//        searchBar.resignFirstResponder()
    }
}


