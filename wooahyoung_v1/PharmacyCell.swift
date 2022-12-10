//
//  PharmacyCell.swift
//  wooahyoung_v1
//
//  Created by lsy on 2022/11/21.
//

import UIKit

class PharmacyCell: UITableViewCell {

    @IBOutlet var lblDistance: UILabel!
    @IBOutlet weak var lblPharmacyName: UILabel!
    @IBOutlet weak var lblPharmacyAddr: UILabel!
    @IBOutlet weak var lblPharmacyCall: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
