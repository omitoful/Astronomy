//
//  TryTableViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/15.
//

import UIKit

class TryTableViewController: UITableViewController {
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
}
