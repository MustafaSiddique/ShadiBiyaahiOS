//
//  HomeVC.swift
//  ShadiBiyah
//
//  Created by Apple on 02/12/2021.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var imgBanner: UIImageView?
    @IBOutlet weak var homeTableView: UITableView!
    var headerView:UIView!
    let headerHeight:CGFloat = 220
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
    }
}

extension HomeVC: UITableViewDelegate{
    
}
extension HomeVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 4 : 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let exploreCell = tableView.dequeueReusableCell(withIdentifier: ExploreTVC.identifier, for: indexPath) as! ExploreTVC
            return exploreCell
        case 1:
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryTVC.identifier, for: indexPath) as! CategoryTVC
            return categoryCell
        case 2:
            let postCell = tableView.dequeueReusableCell(withIdentifier: PostsTVC.identifier, for: indexPath) as! PostsTVC
            return postCell
        default:
            return UITableViewCell()
        }
    }
}

//MARK:- TableView Streachy Header View
extension HomeVC{
    func streatchyHeaderView(){
        headerView = homeTableView.tableHeaderView
        homeTableView.tableHeaderView = nil
        homeTableView.addSubview(headerView)
        homeTableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        homeTableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeader()
    }
    func updateHeader(){
        if homeTableView.contentOffset.y < -120 {
            headerView.frame.origin.y = homeTableView.contentOffset.y
            headerView.frame.size.height = -homeTableView.contentOffset.y
        }
    }
}

//MARK:- Register TableView Cell
extension HomeVC{
    func registerTableViewCell(){
        homeTableView.register(UINib(nibName: ExploreTVC.identifier, bundle: nil), forCellReuseIdentifier: ExploreTVC.identifier)
        homeTableView.register(UINib(nibName: CategoryTVC.identifier, bundle: nil), forCellReuseIdentifier: CategoryTVC.identifier)
        homeTableView.register(UINib(nibName: PostsTVC.identifier, bundle: nil), forCellReuseIdentifier: PostsTVC.identifier)
    }
}
