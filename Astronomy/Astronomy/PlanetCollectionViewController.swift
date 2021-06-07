//
//  PlanetCollectionViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/7.
//

import UIKit

class PlanetCollectionViewController: UICollectionViewController, PicManagerDelegate {
    func information(_ manager: PicManager, didFetch picInfo: [Picture]) {
        <#code#>
    }
    
    func information(_ manager: PicManager, didFetch detailInfo: [DetailInfo]) {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picManerger: PicManager = PicManager.init()
        picManerger.delegate = self
        
        picManerger.getPic()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlanetCollectionViewCell
    
        // Configure the cell
    
        return cell
    }
}
