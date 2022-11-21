//
//  HospitalDetailViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/22.
//

import UIKit
import MapKit

class HospitalDetailViewController: UIViewController, MTMapViewDelegate {
    
    var hospital:Hospital?

    @IBOutlet var DefaultView: UIView!
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
    
    @IBOutlet var dateImage: UIButton!{
        didSet {
            dateImage.isEnabled = false
        }
    }
    @IBOutlet var dutyErynImage: UIButton!{
        didSet {
            dutyErynImage.isEnabled = false
        }
    }
    @IBOutlet var o038Image: UIButton!{
        didSet {
            o038Image.isEnabled = false
        }
    }
    
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
                lbltel1.text = "전화번호: \(hospital.dutyTel1)"
                lbltel2.text = "응급번호: \(hospital.dutyTel3)"
                lblID.text = "진료가능과: \(hospital.dgidIdName)"
                
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
                marker?.customImage = UIImage(named: "hospital_marker")
                marker?.itemName = hospital.dutyName //이름
                marker?.showAnimationType = .noAnimation
                marker?.mapPoint = mapPoint
                mapView.add(marker)
                
                self.view.addSubview(mapView)
            }
        }
        self.view.bringSubviewToFront(DefaultView)
        self.view.bringSubviewToFront(lblName)
        self.view.bringSubviewToFront(starButton)
        
//        dateEnable()
    }
   
    @IBAction func actShare(_ sender: Any) {
        
    }
    
    @IBAction func actCall(_ sender: Any) {
        
    }
    
    @IBAction func actMap(_ sender: Any) {
        
    }
    
    private func dateEnable() {
        
        if hospital?.dutyEryn == 1 {
            self.dutyErynImage.isEnabled = false
        } else {
            self.dutyErynImage.isEnabled = true
        }
        
        
//        self.textField1.addAction(UIAction(handler: { _ in
//            if self.textField1.text?.isEmpty == true {
//                self.dutyErynImage.isEnabled = false
//            } else {
//                self.dutyErynImage.isEnabled = true
//            }
//        }), for: .editingChanged)
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
