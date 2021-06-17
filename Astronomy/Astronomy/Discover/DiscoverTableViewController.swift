//
//  DiscoverTableViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/16.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    var pictures: [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    
    // 建立快取物件
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        fetchRecordsFromCloud()
        
        spinner.style = .large
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 150), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        spinner.startAnimating()
        
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
        
    }

    @objc func fetchRecordsFromCloud() {
        pictures.removeAll()
        tableView.reloadData()
        
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Picture", predicate: predicate)
        // 做排序
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.desiredKeys = ["title", "image"]
        // 做延遲載入
        queryOperation.desiredKeys = ["title"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.pictures.append(record)
        }
        
        queryOperation.queryCompletionBlock = { [unowned self](cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            
            print("Successfully retrieve data.")
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                // 如果下拉更新的話，關閉更新
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        
        // 執行查詢：
        publicDatabase.add(queryOperation)
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell",for: indexPath)
        
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.object(forKey: "title") as? String
        cell.imageView?.image = UIImage(systemName: "questionmark")
        
        // 查看圖片是否存在快取中
        if let imageFileURL = imageCache.object(forKey: picture.recordID) {
            print("Get pic from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        } else {
            
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let fetchOperation = CKFetchRecordsOperation(recordIDs: [picture.recordID])
            fetchOperation.desiredKeys = ["image"]
            fetchOperation.queuePriority = .veryHigh
            
            fetchOperation.perRecordCompletionBlock = { [unowned self](record, recordID, error) -> Void in
                if let error = error {
                    print("Failed to get image - \(error.localizedDescription)")
                    return
                }
                
                if let pictureRecord = record, let image = pictureRecord.object(forKey: "image"), let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                        
                        // 加入圖片至快取
                        self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: picture.recordID)
                        
                    }
                }
                //        if let image = picture.object(forKey: "image"), let imageAsset = image as? CKAsset {
                //            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                //                cell.imageView?.image = UIImage(data: imageData)
                //            }
                //        }
            }
            
            publicDatabase.add(fetchOperation)
        }
        return cell
    }
}
