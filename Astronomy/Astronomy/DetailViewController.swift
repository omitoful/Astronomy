//
//  DetailViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/7.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailCopyright: UILabel!
    @IBOutlet weak var detailDescription: UITextView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var wait: UILabel!
    
    var picture: Picture = Picture(url: "", title: "", hdurl: "", date: "", copyright: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = inputFormatter.date(from: picture.date)
        inputFormatter.dateFormat = "yyyy MMM.dd"
        let result = inputFormatter.string(from: newDate!)

        self.title = "detail"
        self.detailTitle.text = picture.title
        self.detailDate.text = result
        self.detailCopyright.text = picture.copyright
        self.detailDescription.text = picture.description
        
        DispatchQueue.global().async {
            let url = URL(string: self.picture.hdurl)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                self.wait.isHidden = true
                self.detailImage.image = UIImage(data: data!)
            }
        }
    }
}
