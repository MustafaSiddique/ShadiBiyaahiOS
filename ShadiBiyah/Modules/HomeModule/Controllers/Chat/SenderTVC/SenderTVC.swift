//
//  ReceiverTVC.swift
//  FoodChooRider
//
//  Created by Fazeel Ahmed on 03/08/2021.
//

import UIKit
import AVFoundation

class SenderTVC: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView?
    @IBOutlet weak var lblName: UILabelDeviceClass?
    @IBOutlet weak var lblTime: UILabelDeviceClass?
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var viewMedia: UIStackView!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var btnVideoPlayer: UIButton!

    func setData(data: ChatModel){
        guard let user = AppStateManager.sharedInstance.loggedInUser else {return}
        let filePath = user.profileImage ?? ""
        self.imgProfile?.setProfileImage(filePath: filePath)
        
        self.lblName?.text = "\(data.customer?.firstName ?? "") \(data.customer?.lastName ?? "")"
        
        let chatDateString = data.createdAt ?? "2020-12-09T13:45:44.592Z"
        let chatDate = Utility.main.stringDateFormatter(dateStr: chatDateString, dateFormat: Constants.serverDateFormat, formatteddate: "h:mm a, dd MMM yy")
        self.lblTime?.text = chatDate
        
        self.viewMessage.isHidden = (data.messageType ?? "") != MessageType.Text.rawValue
        self.viewMedia.isHidden = (data.messageType ?? "") == MessageType.Text.rawValue
        self.viewVideoPlayer.isHidden = (data.messageType ?? "") != MessageType.Video.rawValue
        
        switch (data.messageType ?? "") {
        case MessageType.Text.rawValue:
            self.tvMessage.text = data.message ?? ""
        case MessageType.Image.rawValue:
            let imageURL = "\(Constants.BaseS3URL)\(data.message ?? "")"
            self.imgPicture.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "ImagePlaceHolder"))
        case MessageType.Video.rawValue:
            let imageURL = "\(Constants.BaseS3URL)\(data.thumbnail ?? "")"
            self.imgPicture.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "ImagePlaceHolder"))
        default:
            break
        }
    }
}
