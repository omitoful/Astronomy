//
//  PlanetTableViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/9.
//

import UIKit

class PlanetTableViewController: UITableViewController, PicManagerDelegate {
    var cellpictures: [Picture] = []
    var cellCheck: [Bool] = []
    
    func information(_ manager: PicManager, didFetch picInfo: [Picture]) {
        self.cellpictures = []
        self.cellpictures.append(contentsOf: picInfo)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cellpictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! PlanetTableViewCell
        
        let picture: Picture = cellpictures[indexPath.row]
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = inputFormatter.date(from: picture.date)
        inputFormatter.dateFormat = "yyyy MMM.dd"
        let result = inputFormatter.string(from: newDate!)
        
        tableCell.tableCellDate.text = result
        tableCell.tabelCellTiltle.text = picture.title
        
        DispatchQueue.global().async {
            let url = URL(string: picture.url)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                tableCell.tableCellImage.image = UIImage(data: data!)
                tableCell.tableCellImage.layer.cornerRadius = 30
            }
        }
        // debug the recicle of tableViewCell:
        if cellCheck[indexPath.row] == true {
//            tableCell.accessoryType = .checkmark
            tableCell.accessoryView = UIImageView.init(image: UIImage(systemName: "heart"))
        } else {
            tableCell.accessoryView = UIImageView.init(image: nil)
        }
        
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
            self.cellpictures.remove(at: indexPath.row)
            print("complete remove \(self.cellpictures[indexPath.row].title)")
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAct.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAct.image = UIImage(systemName: "trash")
        
        let shareAct = UIContextualAction(style: .normal, title: "Share", handler: { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at \(self.cellpictures[indexPath.row].title)"
            
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
                destination.picture = cellpictures[indexPath.row]
            }
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
