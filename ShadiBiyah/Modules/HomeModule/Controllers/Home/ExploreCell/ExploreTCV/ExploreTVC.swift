//
//  ExploreTVC.swift
//  ShadiBiyah
//
//  Created by Apple on 02/12/2021.
//

import UIKit

class ExploreTVC: UITableViewCell {

    @IBOutlet weak var exploreCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        self.registerCollectionViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: Register CollectionView Cell
extension ExploreTVC{
    func registerCollectionViewCell(){
        debugPrint("registered!!!")
        self.exploreCollectionView.register(UINib(nibName: ExploreCVC.identifier, bundle: nil), forCellWithReuseIdentifier: ExploreCVC.identifier)
    }
}

extension ExploreTVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
}

extension ExploreTVC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let exploreCell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCVC.identifier, for: indexPath) as! ExploreCVC
        return exploreCell
    }
}

extension ExploreTVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(14.0)
    }
}
