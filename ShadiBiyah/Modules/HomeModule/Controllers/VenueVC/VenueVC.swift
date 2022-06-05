//
//  VenueVC.swift
//  FoodChooRider
//
//  Created by Apple on 20/02/2022.
//

import UIKit
import FittedSheets

class VenueVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onBtnReset(_ sender: UIButtonDeviceClass) {
        self.presentSelectDataVC()
    }
    
    private func presentSelectDataVC(){
        
        let controller = SelectDateVC()
        //.fixed(300),
        let sheetController = SheetViewController(controller: controller, sizes: [  .halfScreen,])
        // Adjust how the bottom safe area is handled on iPhone X screens
        sheetController.blurBottomSafeArea = false
        sheetController.adjustForBottomSafeArea = true
        sheetController.topCornersRadius = 10
        // Disable the dismiss on background tap functionality
        sheetController.dismissOnBackgroundTap = true
        // Extend the background behind the pull bar instead of having it transparent
        sheetController.extendBackgroundBehindHandle = true
        // Change the overlay color
        //sheetController.overlayColor = UIColor.red
        // Change the handle color
        sheetController.handleColor = .cyan
        sheetController.handleSize = CGSize(width: 26, height: 2)
        // sheetController.handleColor = .gray
        sheetController.pullBarView.isHidden = false
        self.present(sheetController, animated: false, completion: nil)
    }

}
