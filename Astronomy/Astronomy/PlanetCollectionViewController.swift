//
//  PlanetCollectionViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/7.
//

import UIKit

class PlanetCollectionViewController: UICollectionViewController, PicManagerDelegate {
    
    var cellpictures: [Picture] = []
    
    func information(_ manager: PicManager, didFetch picInfo: [Picture]) {
        self.cellpictures = []
        self.cellpictures.append(contentsOf: picInfo)
        print("1")
        DispatchQueue.main.async (
            execute: { () -> Void in
                print("3")
                let _ = self.collectionView.reloadData()
                return ()
            }
        )
        print("2")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picManager: PicManager = PicManager.init()
        picManager.delegate = self
        
        picManager.getPic()
        
        let itemSpace: CGFloat = 3
        let columnCount: CGFloat = 4
                
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
                
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
        flowLayout?.itemSize = CGSize(width: width, height: width)
                
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.cellpictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlanetCollectionViewCell
    
        let picture: Picture = cellpictures[indexPath.row]
        DispatchQueue.global().async {
            let url = URL(string: picture.url)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.cellImage.image = UIImage(data: data!)
            }
        }
        cell.cellTitle.text = picture.title
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailInfo: Picture = cellpictures[indexPath.row]
//        print(detailInfo)
        let info = ["url": detailInfo.url,
                    "hdurl": detailInfo.hdurl,
                    "title": detailInfo.title,
                    "date": detailInfo.date,
                    "copyright": detailInfo.copyright,
                    "description": detailInfo.description]
        
        let userdefault = UserDefaults.standard
        userdefault.set(info, forKey: "detailInfo")
        
    }
}
