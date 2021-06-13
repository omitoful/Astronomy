//
//  MoreDetailViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/10.
//

import UIKit

class MoreDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailContext") as! ContextTableViewCell
            
            cell.contextImage.image = UIImage(systemName: "phone")
            cell.contextLabel.text = "0800-000-000"
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailContext") as! ContextTableViewCell
            
            cell.contextImage.image = UIImage(systemName: "map")
            cell.contextLabel.text = "115台北市南港區南港路一段313號"
            cell.contextLabel.numberOfLines = 0
            cell.selectionStyle = .none
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailText") as! TextTableViewCell
            cell.descriptionLabel.text = picture.description
            cell.descriptionLabel.numberOfLines = 0
            cell.selectionStyle = .none
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Separator") as! SeparatorTableViewCell
            cell.separatorLabel.text = "HOW TO GET HERE?"
            cell.selectionStyle = .none
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Map") as! MapTableViewCell
            cell.selectionStyle = .none
            cell.configure(location: "115台北市南港區南港路一段313號")
            
            return cell
        default:
            fatalError("Fail to instantiate the table view cell for MoreDetailViewController.")
        }
        
    }
    
    
    @IBOutlet weak var moreTitle: UILabel!
    @IBOutlet weak var moreDate: UILabel!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var ratingImage: UIImageView!
    
    var picture = Picture(url: "", title: "", hdurl: "", date: "", copyright: "", description: "", rating: "")

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
        detailTableView.contentInsetAdjustmentBehavior = .never
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMap" {
            let destination = segue.destination as! MapViewController
            destination.picture = self.picture
        } else if segue.identifier == "ShowReview" {
            let destination = segue.destination as! ReviewViewController
            destination.picture = self.picture
        }
    }
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ratePicture(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            self.picture.rating = rating
            self.ratingImage.image = UIImage(named: rating)
            
            let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.ratingImage.transform = scaleTransform
            self.ratingImage.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.ratingImage.transform = .identity
                self.ratingImage.alpha = 1
            }, completion: nil)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
}
