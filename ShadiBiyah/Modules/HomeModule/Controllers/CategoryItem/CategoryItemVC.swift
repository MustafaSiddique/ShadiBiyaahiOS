//
//  CategoryItemVC.swift
//  ShadiBiyah
//
//  Created by Apple on 05/12/2021.
//

import UIKit

class CategoryItemVC: UIViewController {

    @IBOutlet weak var categoryItemTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        categoryItemTableView.delegate = self
        categoryItemTableView.dataSource = self
    }
}

extension CategoryItemVC: UITableViewDelegate{
    
}
extension CategoryItemVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let exploreCell = tableView.dequeueReusableCell(withIdentifier: CategoryItemTVC.identifier, for: indexPath) as! CategoryItemTVC
        return exploreCell
    }
}

//MARK:- Register TableView Cell
extension CategoryItemVC{
    func registerTableViewCell(){
        categoryItemTableView.register(UINib(nibName: CategoryItemTVC.identifier, bundle: nil), forCellReuseIdentifier: CategoryItemTVC.identifier)
    }
}
