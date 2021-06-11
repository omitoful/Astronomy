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
        
        DispatchQueue.main.async (
            execute: { () in
                self.collectionView.reloadData()
            }
        )
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollection"{
            if let indexPaths = self.collectionView.indexPathsForSelectedItems {
                let indexPath = indexPaths[0] as NSIndexPath
                let destination = segue.destination as! DetailViewController
                destination.picture = self.cellpictures[indexPath.row]
            }
        }
    }
}
