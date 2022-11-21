//
//  HospitalCell.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit

class HospitalCell: UITableViewCell {

    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var lblHospitalAddr: UILabel!
    @IBOutlet weak var lblHospitalCall: UILabel!
    
    @IBOutlet var dateImage: UIButton!{
        didSet {
            dateImage.isEnabled = false
        }
    }
    @IBOutlet var holiImage: UIButton!{
        didSet {
            holiImage.isEnabled = false
        }
    }
    @IBOutlet var nightImage: UIButton!{
        didSet {
            nightImage.isEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        dateEnable()
    }
//    private func dateEnable() {
//        self.textField1.addAction(UIAction(handler: { _ in
//            if self.textField1.text?.isEmpty == true {
//                self.LoginButton.isEnabled = false
//            } else {
//                self.LoginButton.isEnabled = true
//            }
//        }), for: .editingChanged)
//    }
}
