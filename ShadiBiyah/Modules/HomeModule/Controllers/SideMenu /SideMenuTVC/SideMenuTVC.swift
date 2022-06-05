//
//  SideMenuTVC.swift
//  FoodChoo
//
//  Created by MacBook Pro on 03/08/2021.
//

import UIKit

class SideMenuTVC: UITableViewCell {

    @IBOutlet weak var imgOptions: UIImageView?
    @IBOutlet weak var lblOptions: UILabel?
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var statusView: UIView!
    
    func setData(_ data : SideMenuOption?) {
        self.imgOptions?.image = data?.icon
        self.lblOptions?.text = data?.option
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
