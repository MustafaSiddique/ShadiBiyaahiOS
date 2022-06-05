//
//  NotificationsTVC.swift
//  FoodChooRider
//
//  Created by Fazeel Ahmed on 30/07/2021.
//

import UIKit

class NotificationsTVC: UITableViewCell {

    @IBOutlet weak var lblOrderTitle: UILabelDeviceClass?
    @IBOutlet weak var lblOrderDetail: UILabelDeviceClass?
    @IBOutlet weak var lblTime: UILabelDeviceClass?
    @IBOutlet weak var btnReview: UIButtonDeviceClass?
    @IBOutlet weak var isReadNotification: RoundedView!
    @IBOutlet weak var imgNotification: RoundedImage!
    @IBOutlet weak var tvUrl: UITextViewDeviceClass!
}
extension NotificationsTVC {
     func setData(data: NotificationsModel){
         
         let status:Bool = data.title == NotificationStatusType.OrderCompleted.rawValue ?  true : false
         
         self.imgNotification.setNotificationImage(filePath: data.image ?? "", status: status)
         
         self.lblOrderTitle?.text = data.title ?? ""
         self.lblOrderDetail?.text = data.message ?? ""
         
         let notificationDateString = data.createdAt ?? ""
         let notificationDate = Utility.main.stringDateFormatter(dateStr: notificationDateString, dateFormat: Constants.serverDateFormat, formatteddate: "E, h:mm a")
         self.lblTime?.text = notificationDate
         
         self.tvUrl.delegate = self
         self.tvUrl.isHidden = data.url == nil
         self.tvUrl.text = data.url
         
         if data.title == NotificationStatusType.OrderCompleted.rawValue && data.orderId?.driverReview?.ratings == 0 {
             self.btnReview?.isHidden = false
         }
         else {
             self.btnReview?.isHidden = true
         }
         
         self.isReadNotification.backgroundColor = data.isRead ? .lightGray : Global.APP_COLOR
    }
}
extension NotificationsTVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        Utility.main.openURL(url: URL)
        return true
    }
}
