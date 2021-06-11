//
//  MoreDetailViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/10.
//

import UIKit

class MoreDetailViewController: UIViewController {
    
    @IBOutlet weak var moreTitle: UILabel!
    @IBOutlet weak var moreDate: UILabel!
    @IBOutlet weak var moreImage: UIImageView!
    
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
        
    }
}
