//
//  Utils.swift
//  wooahyoung_v1
//
//  Created by miyoungji on 2022/11/30.
//

import Foundation
import UIKit

func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    let hour = seconds / 3600
    let min = (seconds % 3600) / 60
    let sec = (seconds % 3600) % 60
    var result =  ""
    if hour != 0 { result += String(hour)+":" }
    if min != 0 { result += String(min)+":" }
    if sec < 10 { result += "0"+String(sec) }else{ result += String(sec) }
 
  return result
}


func subString (str: String ,start:Int ,end:Int) -> String {
    let startIndex = str.index(str.startIndex, offsetBy: start)// 사용자지정 시작인덱스
    let endIndex = str.index(str.startIndex, offsetBy: end)// 사용자지정 끝인덱스
    let sliced_str = str[startIndex ..< endIndex]
    return String(sliced_str)
}


func copyFile(_ originPath: String,_ targetPath: String) {
   let fileManager = FileManager.default
   
   if !fileManager.fileExists(atPath: targetPath){
       do{
           try  fileManager.copyItem(atPath: originPath, toPath: targetPath)
       }catch{
           print("plist를 복사하는데 실패했습니다.")
       }
   }
}

func getFilePath(fileName:String)->String{
   //document 경로 구하기
   let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
   //String <-> NSString 형변환 무조건 보장되기 때문에 as? 할 필요없음(옵셔널 붙일 필요 없음)
   let docPath = docDir[0] as NSString
//   print("docPath:", docPath)
   
   //String -> Struct
   //NSString -> Class
   let targetPath = docPath.appendingPathComponent(fileName)
   print("targetPath:",targetPath)
   return targetPath
}

func readFile(file:String){
    let fileName = file + ".plist"
    let targetPath = getFilePath(fileName: fileName)
    //path는 무조건 optional
    guard let originPath = Bundle.main.path(forResource: file, ofType: "plist") else {return}
//        print("originPath:",originPath)
    
    copyFile(originPath,targetPath)
    
//    bts = NSMutableArray(contentsOfFile: targetPath)
}



func printType(_ value: Any) {
    let types = type(of: value)
    print("\(value) of type \(types)")
}

func docUrlFileName(_ fileName:String)->URL{
    //document dir의 경로 획득 -> UIImage -> Data -> write
    let fileManager = FileManager.default //sigleton? 객체라서 이렇게 생성
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let docUrl = paths[0]
//        print("docPath:",docPath)
    let fileUrl = docUrl.appending(component: fileName)
        print("fileUrl:", fileUrl)
    return fileUrl
}

func saveImageWithUrl(_ url: URL, image: UIImage?, quality: CGFloat=0.5) throws{
    if let image = image , let data = image.jpegData(compressionQuality: quality) {
        // try? data.write(to: url) //예외처리 안 해도 될 때
        do {
            try data.write(to: url)
        }catch{
          throw error
        }
    }
}

func makeAlertWithOneAction(title:String?, message:String?, actionTitle:String="확인", actionStyle:UIAlertAction.Style = .default) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style: actionStyle)
    alert.addAction(action)

    return alert
}
