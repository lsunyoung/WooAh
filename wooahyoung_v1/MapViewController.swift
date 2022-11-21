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
    var page = 1
    
    @IBOutlet var MenuButton: UIButton!
    @IBOutlet var MyLocationBtn: UIButton!
    @IBOutlet var HospitalBtn: UIButton!
    @IBOutlet var PharmacyBtn: UIButton!
    @IBOutlet var FavoritesBtn: UIButton!
    
    var mapPoint: MTMapPoint?
    var marker: MTMapPOIItem?
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    var latitude : Double = 37.53737528
    var longitude : Double = 127.00557633
    
    var allCircle = [MTMapCircle]()
    
    var locationManager = CLLocationManager() //좌표를 얻어오기 위한 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            mapView.delegate = self // 델리게이트 연결
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등을 설정)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  latitude, longitude: longitude)), zoomLevel: 5, animated: true)
            self.view.addSubview(mapView)
        }
        //bringSubviewToFront 맨앞으로
        self.view.bringSubviewToFront(MyLocationBtn)
        self.view.bringSubviewToFront(HospitalBtn)
        self.view.bringSubviewToFront(PharmacyBtn)
        self.view.bringSubviewToFront(FavoritesBtn)
        
        Menu()
        search()
    }
    func Menu() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "즐겨찾기", image: UIImage(named: "Star"), handler: { (_) in
                }),
//                UIAction(title: "빠른검색", image: UIImage(systemName: "magnifyingglass"), handler: { (_) in
//                }),
                UIAction(title: "현재 진료가능 병원", image: UIImage(named: "Hospital3"), handler: { (_) in
                }),
                UIAction(title: "현재 방문가능 약국", image: UIImage(named: "Drug3"), handler: { (_) in
                }),
                UIAction(title: "달빛어린이 병원", image: UIImage(named: "Hospital2"), handler: { (_) in
                }),
                UIAction(title: "심야 약국", image: UIImage(named: "Drug2"), handler: { (_) in
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
    func search() {
        //        guard let query = query else {return} //옵셔널임 //http사이트일 경우 info에서 App Transport Security Settings 추가 -> 하위 Allow Arbitrary Loads 추가 -> Value를 Yes로 변경
        let url = "http://172.20.10.3:3000/hospital?name=seoul&code=A&page=1&limit=20" //구로디지털 원광대
        
        print("url:",url)
        //        let params:Parameters = ["query":query, "page": page]
        let alamo = AF.request(url, method: .get/*, parameters: params, headers: nil*/)
        
        alamo.responseDecodable(of: ResultData1.self) { response in
            guard let root = response.value else {return}
            self.hospital = root.hospital
            print(self.hospital)
        }
    }
    
    @IBAction func actMyLocation(_ sender: Any) {
        // 현재 위치 트래킹
        mapView?.currentLocationTrackingMode = .onWithoutHeading
        mapView?.showCurrentLocationMarker = true
        // info에서 Privacy - Location Always and When In Use Usage Description와 Privacy - Location When In Use Usage Description 설정 해줘야 함
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            let currentLat = locationManager.location?.coordinate.latitude ?? 0 //위도
            let currentLng = locationManager.location?.coordinate.longitude ?? 0 //경도
            // print locationManager.location?.coordinate.latitude
            // print locationManager.location?.coordinate.longitude
            print(currentLat)
            print(currentLng)
        }
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
