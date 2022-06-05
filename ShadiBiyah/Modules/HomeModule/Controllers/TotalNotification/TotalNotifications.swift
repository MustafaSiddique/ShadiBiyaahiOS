//
//  TotalNotifications.swift
//  FoodChooRider
//
//  Created by Fazeel Ahmed on 30/07/2021.
//

import UIKit
import RealmSwift
import ObjectMapper
import DZNEmptyDataSet

class TotalNotifications: BaseController {

    @IBOutlet weak var tableView: UITableView?
    
    var refreshControl = UIRefreshControl()
    var firstTime = true
    var arrNotifications = [NotificationsModel]()
    
    var page = 1
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.getUserNotifications()
    }
}
//MARK: Helper Methods
extension TotalNotifications{
    private func setUI(){
        self.title = Strings.NOTIFICATIONS.text
        self.pullToRefresh()
        self.registerCells()
    }
    private func registerCells(){
        self.tableView?.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
    }
    private func pullToRefresh(){
        self.refreshControl.attributedTitle = NSAttributedString(string: Strings.PULL_TO_REFRESH.text)
        self.refreshControl.addTarget(self, action: #selector(self.refreshNotifications), for: UIControl.Event.valueChanged)
        self.tableView?.addSubview(self.refreshControl)
    }
    @objc func refreshNotifications(){
        self.arrNotifications.removeAll()
        self.page = 1
        self.firstTime = true
        self.tableView?.reloadData()
        
        self.getUserNotifications()
    }
    private func setNotifications(){
        self.tableView?.reloadData()
        self.refreshControl.endRefreshing()
    }
}
//MARK: UITableViewDataSource
extension TotalNotifications: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as? NotificationsTVC else {return UITableViewCell()}
        
        cell.btnReview?.addTarget(nil, action: #selector(onBtnReview(_:)), for: .touchUpInside)
        cell.btnReview?.tag = indexPath.row
        cell.setData(data: self.arrNotifications[indexPath.row])
        return cell
    }
    @objc func onBtnReview(_ sender: UIButtonDeviceClass){
        let order = self.arrNotifications[sender.tag].orderId
        
        let controller = ReviewDriver()
        controller.order = order
        self.navigationController?.pushViewController(controller, animated: true)
        
        controller.reviewedOrder = { (isReviewed,driverRatings) in
            if isReviewed {
                self.arrNotifications[sender.tag].orderId?.driverReview?.ratings = driverRatings
                
                let indexPath = IndexPath(row: sender.tag, section: 0)
                self.tableView?.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}
//MARK: UITableViewDelegate
extension TotalNotifications: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if tableView.visibleCells.contains(cell) {
                if indexPath.row == self.arrNotifications.count - 1{
                    self.loadMoreCells()
                }
            }
        }
    }
    
    private func loadMoreCells(){
        if self.page != self.pageCount {
            self.page += 1
            self.getUserNotifications()
        }
    }
}
//MARK: DZNEmptyDataSetSource
extension TotalNotifications: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if self.firstTime {
            let str = Strings.LOADING_NOTIFICATIONS.text
            let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
        let str = Strings.NO_NOTIFICATION_FOUND.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
//MARK: Services
extension TotalNotifications {
    private func getUserNotifications() {
        if self.page != 1 {Utility.showLoader()}
        
        let param:[String:Any] = ["page":self.page]
        
        APIManager.sharedInstance.usersAPIManager.getUserNotification(params: param) { responseObject in
            self.firstTime = false
            
            if let pageCount = (responseObject as Dictionary)["page_count"] as? Int {self.pageCount = pageCount}
            guard let response = responseObject["notifications"] as? [Dictionary<String, Any>] else {return}
            let arrNotifications = Mapper<NotificationsModel>().mapArray(JSONArray: response)
            self.arrNotifications.append(contentsOf: arrNotifications)
            
            self.setNotifications()
        } failure: { error in
            print(error)
        }
    }
}
