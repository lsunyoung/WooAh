//
//  PharmacyDetailViewController.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/24.
//

import UIKit
import MapKit

class PharmacyDetailViewController: UIViewController, MTMapViewDelegate {
    
    var pharmacy:Pharmacy?
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    var mapPoint: MTMapPoint?
    var marker: MTMapPOIItem?
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddr: UILabel!
    @IBOutlet var lbltel1: UILabel!
    @IBOutlet var starButton: StarButton!
    
    @IBOutlet var dateButton: UIButton!{
        didSet {
            dateButton.isEnabled = false
        }
    }
    @IBOutlet var holidayButton: UIButton!{
        didSet {
            holidayButton.isEnabled = false
        }
    }
    @IBOutlet var weekButton: UIButton!{
        didSet {
            weekButton.isEnabled = false
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
    
    @IBOutlet var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            mapView.delegate = self // 델리게이트 연결
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            if let pharmacy = pharmacy {
                lblName.text = pharmacy.dutyName
                lblAddr.text = pharmacy.dutyAddr
                lbltel1.text = pharmacy.dutyTel1
                lblMon.text = "월요일  \(pharmacy.dutyTime1s)-\(pharmacy.dutyTime1c)"
                lblTue.text = "화요일  \(pharmacy.dutyTime2s)-\(pharmacy.dutyTime2c)"
                lblWed.text = "수요일  \(pharmacy.dutyTime3s)-\(pharmacy.dutyTime3c)"
                lblThu.text = "목요일  \(pharmacy.dutyTime4s)-\(pharmacy.dutyTime4c)"
                lblFri.text = "금요일  \(pharmacy.dutyTime5s)-\(pharmacy.dutyTime5c)"
                lblSat.text = "토요일  \(pharmacy.dutyTime6s)-\(pharmacy.dutyTime6c)"
                lblSun.text = "일요일  \(pharmacy.dutyTime7s)-\(pharmacy.dutyTime7c)"
                lblHoli.text = "공휴일  \(pharmacy.dutyTime8s)-\(pharmacy.dutyTime8c)"
                
                // 좌표 찍기1
                mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: pharmacy.wgs84Lat, longitude: pharmacy.wgs84Lon)), zoomLevel: 1, animated: true)
                
                // 핀 찍기
                mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: pharmacy.wgs84Lat, longitude: pharmacy.wgs84Lon))
                marker = MTMapPOIItem()
                // 핀 디자인
                marker?.markerType = .customImage
                marker?.customImage = UIImage(named: "pharmacy_marker_green2")
                marker?.itemName = pharmacy.dutyName //이름
                marker?.showAnimationType = .noAnimation
                marker?.mapPoint = mapPoint
                mapView.add(marker)
                
                self.view.addSubview(mapView)
            }
        }
        self.view.bringSubviewToFront(detailView)
        
        if let pharmacy = pharmacy {
            let date = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH00"
            if pharmacy.dutyTime1s <= "\(formatter.string(from: date as Date))" {
                if pharmacy.dutyTime1c >= "\(formatter.string(from: date as Date))" {
                    self.dateButton.isEnabled = true
                } else {
                    self.dateButton.isEnabled = false
                }
            }
            if pharmacy.dutyTime8s == "" {
                self.holidayButton.isEnabled = false
            } else {
                self.holidayButton.isEnabled = true
            }
            if pharmacy.dutyTime6c == "" {
                self.weekButton.isEnabled = false
            } else {
                self.weekButton.isEnabled = true
            }
        }
        
    }
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        if let url = NSURL(string: "kakaolink://"),
           UIApplication.shared.canOpenURL(url as URL) {
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
    @IBAction func actMap(_ sender: Any) {
        let alert = UIAlertController(title: "카카오맵", message: "카카오맵 길찾기 이동하시겠습니까?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "확인", style: .default) { _ in
            //스키마로 외부 앱 실행(info에 Queried URL Schemes 앱(kakaomap) 추가)
            // kakaomap://route?sp=37.4921839765254,127.03046988548856&ep=\(lat),\(lon)&by=CAR
            // kakaonavi://route?y=${“37.487491418638534”}&x=${“126.92906124401378”}&sX=${“\(lat)”}&sY=${“\(lon)”}
            guard let pharmacy = self.pharmacy else {return}
            let lat:Double = pharmacy.wgs84Lat
            let lon:Double = pharmacy.wgs84Lon
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
    
    @IBAction func actCall(_ sender: Any) {
        guard let pharmacy = pharmacy else {return}
        let number = pharmacy.dutyTel1
        // URLScheme 문자열을 통해 URL 인스턴스를 만들어 줍니다.
        if let url = NSURL(string: "tel://" + "\(number)"),
           //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
           UIApplication.shared.canOpenURL(url as URL) {
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
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
