//
//  TableViewCell.swift
//  Shopping List Manager
//
//  Created by Wiktor Witkowski on 06/12/2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var finalCostLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
