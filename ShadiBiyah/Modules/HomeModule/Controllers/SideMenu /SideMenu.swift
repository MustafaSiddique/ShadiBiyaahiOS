//
//  SideMenu.swift
//  FoodChoo
//
//  Created by MacBook Pro on 03/08/2021.
//

import UIKit
import LGSideMenuController

class SideMenu: UIViewController {
    
    @IBOutlet weak var imgProfile: RoundedImage!
    @IBOutlet weak var lblUserName: UILabelDeviceClass!
    @IBOutlet weak var tableView: UITableView!
    
    var arrSideMenuOptions = [SideMenuOption(icon: UIImage(named: "HomeLightIcon"), option: Strings.HOME.text),
                              SideMenuOption(icon: UIImage(named: "BackIcon"), option: Strings.HOME.text),
                              SideMenuOption(icon: UIImage(named: "BackIcon"), option: Strings.HOME.text),
                              SideMenuOption(icon: UIImage(named: "BackIcon"), option: Strings.HOME.text),
                              SideMenuOption(icon: UIImage(named: "BackIcon"), option: Strings.HOME.text)
//                              SideMenuOption(icon: UIImage(named: "ChatIcon"), option: Strings.CHAT.text),
//                              SideMenuOption(icon: UIImage(named: "ContactSupportIcon"), option: Strings.CONTACT_SUPPORT.text),
//                              SideMenuOption(icon: UIImage(named: "SettingsIcon"), option: Strings.SETTINGS.text),
//                              SideMenuOption(icon: UIImage(named: "LogoutIcon"), option: Strings.LOGOUT.text),
//                              SideMenuOption(icon: UIImage(named: "BonusIcon"), option: Strings.SHARE_FOR_BONUSES.text)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setData()
    }
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBAction func onBtnProfile(_ sender: UIButton) {
        
    }
}
//MARK:- Helper Methods
extension SideMenu {
    private func setUI(){
        self.tableView.register(UINib(nibName: "SideMenuTVC", bundle: nil), forCellReuseIdentifier: "SideMenuTVC")
    }
//    private func setData(){
//        guard let data = AppStateManager.sharedInstance.loggedInUser else {return}
//
//        let filePath = data.profileImage ?? ""
//        self.imgProfile.setProfileImage(filePath: filePath)
//
//        self.lblUserName.text = "\(data.firstName ?? "") \(data.lastName ?? "")"
//    }
}

//MARK:- UITableViewDataSource
extension SideMenu: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSideMenuOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        switch indexPath.row {
        case 4,7:
            cell.bottomView.isHidden = false
            cell.statusView.isHidden = true
        case 8:
            cell.statusView.isHidden = false
            cell.bottomView.isHidden = true
        default:
            cell.statusView.isHidden = true
            cell.bottomView.isHidden = true
        }
        var data : SideMenuOption?
        data = arrSideMenuOptions[indexPath.row]
        cell.setData(data)
        return cell
    }
}
//MARK: UITableViewDelegate
extension SideMenu: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setContentView(indexPath.row)
    }
}
//MARK: Set SideMenu Content
extension SideMenu{
    private func setContentView(_ index: Int){
        self.sideMenuController?.hideLeftViewAnimated(sender: nil)
        switch index {
        case 0:
            break
        case 1:
            print("press case 1")
//        case 2:
//            self.pushToChat()
//        case 3:
//            self.pushToMyProfile()
//        case 4:
//            self.pushToPaymentsTypes()
//        case 5:
//            self.pushToContactSupport()
//        case 6:
//            self.pushToSettings()
//        case 7:
//            AppStateManager.sharedInstance.logoutUser()
//        case 8:
//            self.pushToShareBonus()
        default:
            break
        }
    }
    
    private func topNavigationController() -> UINavigationController {
        guard let topController = Utility.main.topViewController() as? LGSideMenuController else {return UINavigationController()}
        guard let topNavigationController = topController.rootViewController as? UINavigationController else {return UINavigationController()}
        return topNavigationController
    }
//    private func pushToMyOrders(){
//        let controller = MyOrders()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToChat(){
//        let controller = Chat()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToMyProfile(){
//        let controller = Profile()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToPaymentsTypes(){
//        let controller = PaymentTypes()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToContactSupport(){
//        let controller = Chat()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToSettings(){
//        let controller = Settings()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToShareBonus(){
//        let controller = ShareBonus()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToItemDetails(){
//        let controller = ItemDetail()
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
//    private func pushToTermsAndConitions(){
//        let controller = CMS()
//        controller.cmsType = .termsAndCondition
//        self.topNavigationController().pushViewController(controller, animated: true)
//    }
}
//MARK: HELPER FUNCTIONS
extension SideMenu{
    private func setData(){
        guard let user = AppStateManager.sharedInstance.loggedInUser else {return}
//        self.lblUserName?.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
//        let filePath = user.profileImage ?? ""
//        self.imgProfile?.setProfileImage(filePath: filePath)
    }
}
