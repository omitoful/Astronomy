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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userdefault = UserDefaults.standard
        let detailInfo = userdefault.value(forKey: "detailInfo")
        if let info: [String: String] = detailInfo as? [String: String] {
            let title = info["title"]
            let date = info["date"]
            let copyright = info["copyright"]
            let hdurl = info["hdurl"]
            let description = info["description"]
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let newDate = inputFormatter.date(from: date!)
            inputFormatter.dateFormat = "yyyy MMM.dd"
            let result = inputFormatter.string(from: newDate!)

            self.title = "detail"
            self.detailTitle.text = title
            self.detailDate.text = result
            self.detailCopyright.text = copyright
            self.detailDescription.text = description
            
            DispatchQueue.global().async {
                let url = URL(string: hdurl!)
                let data = try? Data(contentsOf: url!)
                
                DispatchQueue.main.async {
                    self.wait.isHidden = true
                    self.detailImage.image = UIImage(data: data!)
                }
            }

            
            
        } else {
            print("Info error.")
        }
    }
}
