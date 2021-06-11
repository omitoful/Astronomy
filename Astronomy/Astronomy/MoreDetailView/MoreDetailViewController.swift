//
//  MoreDetailViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/10.
//

import UIKit

class MoreDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailContext") as! ContextTableViewCell
            
            cell.contextImage.image = UIImage(systemName: "phone")
            cell.contextLabel.text = "0800-000-000"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailContext") as! ContextTableViewCell
            
            cell.contextImage.image = UIImage(systemName: "map")
            cell.contextLabel.text = "115台北市南港區南港路一段313號"
            cell.contextLabel.numberOfLines = 0
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailText") as! TextTableViewCell
            cell.descriptionLabel.text = picture.description
            cell.descriptionLabel.numberOfLines = 0
            
            return cell
        default:
            fatalError("Fail to instantiate the table view cell for MoreDetailViewController.")
        }
        
    }
    
    
    @IBOutlet weak var moreTitle: UILabel!
    @IBOutlet weak var moreDate: UILabel!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var picture = Picture(url: "", title: "", hdurl: "", date: "", copyright: "", description: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moreTitle.text = self.picture.title
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = inputFormatter.date(from: self.picture.date)
        inputFormatter.dateFormat = "yyyy MMM.dd"
        let result = inputFormatter.string(from: newDate!)
        
        self.moreDate.text = result
        
        DispatchQueue.global().async {
            let url = URL(string: self.picture.url)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.moreImage.image = UIImage(data: data!)
                self.moreImage.alpha = 0.7
            }
        }
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.separatorStyle = .none
    }
}
