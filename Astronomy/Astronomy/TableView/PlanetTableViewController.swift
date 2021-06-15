//
//  PlanetTableViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/9.
//

import UIKit
import CoreData

class PlanetTableViewController: UITableViewController, PicManagerDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var cellpictures: [PictureMO] = []
    var cellCheck: [Bool] = []
    @IBOutlet var emptyView: UIView!
    var fetchResult: NSFetchedResultsController<PictureMO>!
    
    var searchController: UISearchController!
    var searchResults: [PictureMO] = []
    
    func information(_ manager: PicManager, didFetch picInfo: [Picture]) {
//        self.cellpictures = []
//        self.cellpictures.append(contentsOf: picInfo)
        
        self.cellCheck = Array(repeating: false, count: cellpictures.count)
        DispatchQueue.main.async (
            execute: { () -> Void in
                let _ = self.tableView.reloadData()
                return ()
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picManager: PicManager = PicManager.init()
        picManager.delegate = self
        
        picManager.getPic()
        
        // for iPad reading:
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        
        
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        
        // fetch load data:
        let fetchRequest: NSFetchRequest<PictureMO> = PictureMO.fetchRequest()
        let sortDesciptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDesciptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResult.delegate = self
            
            do {
                try fetchResult.performFetch()
                if let fetchObjects = fetchResult.fetchedObjects {
                    self.cellpictures = fetchObjects
                }
            } catch {
                print(error)
            }
        }
        
        // search:
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        searchController = UISearchController(searchResultsController: nil)
//        self.navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        // 最後一步，指定目前類別為結果更新器
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchObjects = controller.fetchedObjects {
            cellpictures = fetchObjects as! [PictureMO]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cellpictures.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return self.cellpictures.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! PlanetTableViewCell
        
        // 判斷
        let picture: PictureMO = (searchController.isActive) ? searchResults[indexPath.row] : cellpictures[indexPath.row]
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = inputFormatter.date(from: picture.date!)
        inputFormatter.dateFormat = "yyyy MMM.dd"
        let result = inputFormatter.string(from: newDate!)
        
        tableCell.tableCellDate.text = result
        tableCell.tabelCellTiltle.text = picture.title
        
        if let picimage = picture.image {
            tableCell.tableCellImage.image = UIImage(data: picimage)
        }
        // debug the recicle of tableViewCell:
//        if cellCheck[indexPath.row] == true {
////            tableCell.accessoryType = .checkmark
//            tableCell.accessoryView = UIImageView.init(image: UIImage(systemName: "heart"))
//        } else {
//            tableCell.accessoryView = UIImageView.init(image: nil)
//        }
        
        return tableCell
    }
    
//  there is a swipe to delete func to remove the row, so we dont need this anymore.
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        self.cellpictures.remove(at: indexPath.row)
//        print("complete remove \(self.cellpictures[indexPath.row].title)")
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAct = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, sourceView, completionHandler) in
//            self.cellpictures.remove(at: indexPath.row)
//            print("complete remove \(self.cellpictures[indexPath.row].title!)")
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let picToDelete = self.fetchResult.object(at: indexPath)
                context.delete(picToDelete)
                
                appDelegate.saveContext()
            }
            completionHandler(true)
        })
        deleteAct.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAct.image = UIImage(systemName: "trash")
        
        
        let shareAct = UIContextualAction(style: .normal, title: "Share", handler: { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at \(self.cellpictures[indexPath.row].title!)"
            
            if let imageToShare = UIImage(systemName: "heart") {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                // for iPad pop:
                if let popoverController = activityController.popoverPresentationController {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        popoverController.sourceView = cell
                        popoverController.sourceRect = cell.bounds
                    }
                }
                self.present(activityController, animated: true, completion: nil)
            } else {
                let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                // for iPad pop:
                if let popoverController = activityController.popoverPresentationController {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        popoverController.sourceView = cell
                        popoverController.sourceRect = cell.bounds
                    }
                }
                self.present(activityController, animated: true, completion: nil)
            }
            completionHandler(true)
        })
        shareAct.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAct.image = UIImage(systemName: "square.and.arrow.up.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAct, shareAct])
        
        return swipeConfiguration
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.cellCheck[indexPath.row] == false {
            let checkAct = UIContextualAction(style: .normal, title: "Check In", handler: { (action, sourceView, completionHandler) in
                let tableCell = tableView.cellForRow(at: indexPath)
                tableCell?.accessoryView = UIImageView.init(image: UIImage(systemName: "heart.fill"))
                
                self.cellCheck[indexPath.row] = true
                completionHandler(true)
            })
            checkAct.backgroundColor = UIColor.systemBlue
            checkAct.image = UIImage(systemName: "checkmark")
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkAct])
            return swipeConfiguration
            
        } else {
            let checkAct = UIContextualAction(style: .normal, title: "Undo", handler: { (action, sourceView, completionHandler) in
                let tableCell = tableView.cellForRow(at: indexPath)
                tableCell?.accessoryView = UIImageView.init(image: nil)
                
                self.cellCheck[indexPath.row] = false
                completionHandler(true)
            })
            
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkAct])
            return swipeConfiguration
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destination = segue.destination as! NewDetailViewController
                destination.picture = (searchController.isActive) ? searchResults[indexPath.row] : cellpictures[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func filterContent(for searchText: String) {
        self.searchResults = cellpictures.filter({ picture -> Bool in
            if let title = picture.title {
                let isMatch = title.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    // 依照協定，使用搜尋功能時，這個方法會被直接呼叫
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            // 呼叫我們自己做的過濾方法
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    // 在搜尋器啟動時無法編輯cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    
//    //just for trying didSelectRowAt:
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let alertController = UIAlertController(title: nil, message: "What do you wanna do?", preferredStyle: .actionSheet)
//
//        // for iPad pop:
//        if let popoverController = alertController.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }
//        //-------------------
//
//        let callMessage = { (action: UIAlertAction) -> Void in
//            let callAlert = UIAlertController(title: "Service Unavailable", message: "Sorry,the call is not available yet.Please try again later.", preferredStyle: .alert)
//            callAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//            self.present(callAlert, animated: true, completion: nil)
//        }
//
//        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let callAct = UIAlertAction(title: "Call 123-\(indexPath.row)", style: .default, handler: callMessage)
//        alertController.addAction(cancelAct)
//        alertController.addAction(callAct)
//
//        if cellCheck[indexPath.row] == false {
//            let checkInAct = UIAlertAction(title: "Check In", style: .default, handler: { (action: UIAlertAction) -> Void in
//                let tableCell = tableView.cellForRow(at: indexPath)
////                tableCell?.accessoryType = .checkmark
//                tableCell?.accessoryView = UIImageView.init(image: UIImage(systemName: "heart"))
//
//                self.cellCheck[indexPath.row] = true
//            })
//            alertController.addAction(checkInAct)
//        } else {
//            let checkInAct = UIAlertAction(title: "Undo Check In", style: .default, handler: { (action: UIAlertAction) -> Void in
//                let tableCell = tableView.cellForRow(at: indexPath)
////                tableCell?.accessoryType = .none
//                tableCell?.accessoryView = UIImageView.init(image: nil)
//
//                self.cellCheck[indexPath.row] = false
//            })
//            alertController.addAction(checkInAct)
//        }
//
//        present(alertController, animated: true, completion: nil)
//
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
    
}
