//
//  FavoriteTableViewController.swift
//  wooahyoung_v1
//
//  Created by miyoungji on 2022/11/29.
//

import UIKit

class FavoriteTableViewController: UITableViewController {

    @IBOutlet var segBtn: UISegmentedControl!
    
    var fileName:String = ""
    //var fileName = "FavoriteHospitalList"
    var favoriteList:NSMutableArray?
    var searchList:[[String:Any]] = [] //검색내용
    var searchPageList:[[String:Any]] = [] //페이징처리한 리스트
    var filtered:[[String:Any]] = []
    
    var page = 1
    var defaultText = ""
    let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 130
        //Add UISegmented
        self.segconChanged(segcon: segBtn)
        
        let targetPath = getFilePath(fileName: fileName+".plist")
        //path는 무조건 optional
        guard let originPath = Bundle.main.path(forResource: fileName, ofType: "plist") else {return}
        copyFile(originPath,targetPath)
        
        guard let favoriteList = NSMutableArray(contentsOfFile: targetPath) else {return}
        self.favoriteList = favoriteList
        searchList = favoriteList as! [[String : Any]]
        print("좋아요 초반 ", self.favoriteList)
        print("좋아요 초반 searchList ", searchList)
        
        //search(defaultText, page)
    }
    
    //Create segmentedControl
    var segCon:UISegmentedControl {
        let sc:UISegmentedControl = UISegmentedControl(items:[])
        
    //Add an event
        sc.addTarget(self, action:#selector(segconChanged(segcon:)), for: UIControl.Event.menuActionTriggered)
        
        return sc
    }
    

    @objc func segconChanged(segcon: UISegmentedControl) {
        
        switch segBtn.selectedSegmentIndex {
        case 0 :
            // 병원
            fileName = "FavoriteHospitalList"
        case 1 :
            // 약국
            fileName = "FavoritePharmacyList"
        default : fileName = "FavoriteHospitalList"
            
        }
        
    }
    
    @IBAction func segBtn(_ sender: Any) {
        self.segconChanged(segcon: segBtn)
        
        let targetPath = getFilePath(fileName: fileName+".plist")
        //path는 무조건 optional
        guard let originPath = Bundle.main.path(forResource: fileName, ofType: "plist") else {return}
        copyFile(originPath,targetPath)
        
        guard let favoriteList = NSMutableArray(contentsOfFile: targetPath) else {return}
        self.favoriteList = favoriteList
        
        DispatchQueue.main.async {
            self.tableView.reloadData() //mainQueue에서 작업해야됨!!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let targetPath = getFilePath(fileName: fileName+".plist")
//        //path는 무조건 optional
//        guard let originPath = Bundle.main.path(forResource: fileName, ofType: "plist") else {return}
//        copyFile(originPath,targetPath)
//
//        guard let favoriteList = NSMutableArray(contentsOfFile: targetPath) else {return}
//        self.favoriteList = favoriteList
//        searchList = favoriteList as! [[String : Any]]
//        print("좋아요 리로드 ", self.favoriteList)
//        print("좋아요 리로드 searchList ", searchList)
//        search(defaultText, page)
    }
    
    func search(_ query: String?, _ page: Int){
//        if query == "" { return } //초기에 빈 검색어일 때
        guard let query = query else {return}
        guard let tmpList = self.favoriteList else {fatalError()}
    
        if let tmpList = tmpList as? [[String: Any]] {
            if query != "" {
              print("빈 검색어")
                searchList = tmpList
           }else{
                print("query",query)
                searchList = tmpList.filter {
                    ($0["dutyName"] as? String)?
                        .range(of: query, options: [.caseInsensitive]) != nil
                    ||
                    ($0["dutyAddr"] as? String)?
                        .range(of: query, options: [.caseInsensitive]) != nil
                }
            }
       
            filtered = searchList
           
//            var lastIndex = searchPageList.count - 1
//
//            let startIndex = (page-1) * pageSize
//            let endIndex = (page*pageSize) - 1
//
//            print("lastIndex",lastIndex)
//            print("startIndex",startIndex)
//            print("endIndex",endIndex)
//            if endIndex < lastIndex{
//                searchPageList = Array(searchList[startIndex...endIndex])
//            }else{
//                searchPageList = Array(searchList[startIndex...lastIndex])
//            }
//            print("searchPageList",searchPageList)
            favoriteList?.setArray(filtered)
            
            DispatchQueue.main.async {
                self.tableView.reloadData() //mainQueue에서 작업해야됨!!
                //self.btnNext.isEnabled = lastIndex > endIndex

                
            }
        }

        //btnPrev.isEnabled = page > 1
    }
    
//    @IBAction func actPrev(_ sender: Any) {
//        page -= 1
//        search(defaultText, page)
//    }
//
//    @IBAction func actNext(_ sender: Any) {
//        page += 1
//        search(defaultText, page)
//    }
    
  //segmented Control
//    
//    if segBtn.selectedSegmentIndex == 0 {
//       
//        
////
//    } else {
//
//
//
//
//    }
//    
//    
    
    
    @IBAction func actBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actRemove(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at:buttonPosition){
            guard let favoriteList = self.favoriteList else {fatalError()}
            //let selectInfo = searchPageList[indexPath.row] //selected
            let selectInfo = self.favoriteList?[indexPath.row] as! [String : Any]  //selected
            
            print("selectInfo",selectInfo)
            var removeIndex = 0
            for (i, ele) in favoriteList.enumerated(){
                if let ele = ele as? [String:Any]  {
                    if ele["hpid"] as! String == selectInfo["hpid"] as? String  {
                        print("삭제할 인덱스! : ",i)
                        removeIndex = i
                        break
                    }
                }
            }//for end
            
            favoriteList.removeObject(at: removeIndex)
            let filePath = getFilePath(fileName: fileName+".plist")
            let result =  favoriteList.write(toFile: filePath, atomically: true)
            if result {
                print("searchPageList index",indexPath.row)
//                searchPageList.remove(at: indexPath.row)
//                print("cnt", searchPageList.count)

                
                let alert = UIAlertController(title: nil, message: "삭제 되었습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { (action) in
                    DispatchQueue.main.async {
                        print("reload")
                        self.tableView.reloadData() //mainQueue에서 작업해야됨!!
                    }
                }
                alert.addAction(action)
                present(alert, animated:true)
            }else{
                let alert = makeAlertWithOneAction(title: nil, message: "삭제 실패했습니다.")
                present(alert, animated: true)
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let favoriteList = favoriteList?.count {
            return favoriteList
        } else { return 0}

       
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritecell", for: indexPath)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritecell", for: indexPath) as? favoriteCell else {fatalError()}
        //let favoriteInfo = searchPageList[indexPath.row]
        let favoriteInfo = self.favoriteList?[indexPath.row] as! [String : Any]

        let favName = cell.viewWithTag(1) as? UILabel
        //favName?.text = favoriteInfo["dutyName"] as? String
        favName?.text = favoriteInfo["dutyName"] as? String

        let favAddr = cell.viewWithTag(2) as? UILabel
        favAddr?.text = favoriteInfo["dutyAddr"] as? String

        let favCall = cell.viewWithTag(3) as? UILabel
        favCall?.text = favoriteInfo["dutyTel1"] as? String

//        let favName = cell.viewWithTag(1) as? UILabel
//        favName?.text = "test Name"
//
//        let favAddr = cell.viewWithTag(2) as? UILabel
//        favAddr?.text = "test addr"
//
//        let favCall = cell.viewWithTag(3) as? UILabel
//        favCall?.text = "010-1111-4444"
        return cell
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let index = tableView.indexPathForSelectedRow else {return}
//        let dvc = segue.destination as? DetailViewController
//        dvc?.site = searchList[index.row]["url"] as! String
//    }
//
//
//}

//extension FavoriteTableViewController:UISearchBarDelegate {
//     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            page = 1
//            defaultText = searchBar.text!
//            search(defaultText, page)
//            searchBar.resignFirstResponder() //키보드내림
//    }
    
}
