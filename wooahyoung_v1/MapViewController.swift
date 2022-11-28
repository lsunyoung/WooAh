//
//  MapViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {
    
    var hospital:[Hospital] = []
    var pharmacy:[Pharmacy] = []
    var page = 1
    
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
    
    var latitude : Double = 37.53737528
    var longitude : Double = 127.00557633
    
    var allCircle = [MTMapCircle]()
    
    var locationManager = CLLocationManager() //좌표를 얻어오기 위한 변수
    var la:Double!
    var lo:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hospitalSearch(mylat: 37.48652777387346, mylon: 126.8993736808353)
//        pharmacySearch(mylat: 37.5170112, mylon: 126.9019532)
        hospitalSearch(with:"여의도")
        pharmacySearch(with:"여의도")
        
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

//        guard let la = la else {return}
//        guard let lo = lo else {return}
//        print(la)
//        print(lo)
    }
    func Menu() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "즐겨찾기", image: UIImage(named: "Star"), handler: { (_) in
                }),
                UIAction(title: "현재 진료가능 병원", image: UIImage(named: "hospital"), handler: { (_) in
                }),
                UIAction(title: "현재 방문가능 약국", image: UIImage(named: "pharmacy"), handler: { (_) in
                }),
                UIAction(title: "달빛어린이 병원", image: UIImage(named: "moonhospital"), handler: { (_) in
                }),
                UIAction(title: "심야 약국", image: UIImage(named: "moonpharmacy"), handler: { (_) in
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
    
    func hospitalSearch(with addr:String?/*, mylat:Double, mylon:Double*/) {
        guard let addr = addr else {return}
//        let url = "https://wooahwooah.azurewebsites.net/hospital?mylon=\(mylon)&mylat=\(mylat)&page=1&limit=20"
        let url = "https://wooahwooah.azurewebsites.net/hospital?page=1&limit=30"

        print("url:",url)
        let params:Parameters = ["addr": addr]
        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)

        alamo.responseDecodable(of: ResultData1.self) { response in
            
            print(response)
            guard let root = response.value else {return}
            self.hospital = root.hospital
//            print(self.hospital)
            self.mapPOIhospital()
        }
    }
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
    func pharmacySearch(with addr:String?/*, mylat:Double, mylon:Double*/) {
        guard let addr = addr else {return}
//        let url = "https://wooahwooah.azurewebsites.net/pharmacy?mylon=\(mylon)&mylat=\(mylat)&page=1&limit=20"
        let url = "https://wooahwooah.azurewebsites.net/pharmacy?page=1&limit=30"
//        guard let strURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        print("url:",url)
        let params:Parameters = ["addr": addr]
        let alamo = AF.request(url, method: .get, parameters: params/*, headers: nil*/)
        
        alamo.responseDecodable(of: ResultData2.self) { response in
            guard let root = response.value else {return}
            self.pharmacy = root.pharmacy
//            print(self.hospital)
            self.mapPOIpharmacy()
        }
    }
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

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first { // 위치 정보 계속 업데이트
            la = location.coordinate.latitude
            lo = location.coordinate.longitude
//            guard let la = la else {return}
//            guard let lo = lo else {return}
//            print("위도: \(la)")
//            print("경도: \(lo)")
//            hospitalSearch(mylat: lo, mylon: la)
        }
    }
    @IBAction func actMyLocation(_ sender: Any) {
        // 현재 위치 트래킹
        mapView?.currentLocationTrackingMode = .onWithoutHeading
        mapView?.showCurrentLocationMarker = true
//        guard let la = la else {return}
//        guard let lo = lo else {return}
//
//        hospitalSearch(mylat: lo, mylon: la)
        // info에서 Privacy - Location Always and When In Use Usage Description와 Privacy - Location When In Use Usage Description 설정 해줘야 함
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//            let currentLat = locationManager.location?.coordinate.latitude ?? 0 //위도
//            let currentLng = locationManager.location?.coordinate.longitude ?? 0 //경도
//            // print locationManager.location?.coordinate.latitude
//            // print locationManager.location?.coordinate.longitude
////            print(currentLat)
////            print(currentLng)
//        }
    }
    
    @IBAction func actHospital(_ sender: Any) {
        
    }
    @IBAction func actPharmacy(_ sender: Any) {
        
    }
    @IBAction func actFavorite(_ sender: Any) {
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? HospitalTableViewController
        vc?.la = la
        vc?.lo = lo
        guard let searchtext = searchtext else {return}
        vc?.searchtext = searchtext
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let mapView = mapView {
            mapView.removeAllPOIItems() // 검색 시 poiitems 지워짐
        }
        let searchtext = searchBar.text
        hospitalSearch(with:searchtext)
        pharmacySearch(with:searchtext)
        searchBar.resignFirstResponder()
        
    }
}
