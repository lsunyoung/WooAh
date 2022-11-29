//
//  Data.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import Foundation

struct Hospital:Codable {
//    let hpid:String
    let dutyName:String
    let dutyTel1:String
    let dutyTel3:String
        let dutyTime1c:String
        let dutyTime2c:String
        let dutyTime3c:String
        let dutyTime4c:String
        let dutyTime5c:String
        let dutyTime6c:String
        let dutyTime7c:String
        let dutyTime8c:String
        let dutyTime1s:String
        let dutyTime2s:String
        let dutyTime3s:String
        let dutyTime4s:String
        let dutyTime5s:String
        let dutyTime6s:String
        let dutyTime7s:String
        let dutyTime8s:String
    let dutyAddr:String
    //    let postCdn1:String
    //    let postCdn2:String
    let dgidIdName:String
    let wgs84Lon:Double
    let wgs84Lat:Double
    let dutyEryn:Int //응급실 1은 없음 2은 있음
    let o038:String //입원실
//    let avalhospital:Int //진료가능
}
struct Pharmacy:Codable {
//    let hpid:String
    let dutyName:String
    let dutyTel1:String
    let dutyAddr:String
    let wgs84Lon:Double
    let wgs84Lat:Double
    let dutyTime1c:String
    let dutyTime2c:String
    let dutyTime3c:String
    let dutyTime4c:String
    let dutyTime5c:String
    let dutyTime6c:String
    let dutyTime7c:String
    let dutyTime8c:String
    let dutyTime1s:String
    let dutyTime2s:String
    let dutyTime3s:String
    let dutyTime4s:String
    let dutyTime5s:String
    let dutyTime6s:String
    let dutyTime7s:String
    let dutyTime8s:String
}
struct ResultData1:Codable {
    let hospital:[Hospital]
}
struct ResultData2:Codable {
    let pharmacy:[Pharmacy]
}
