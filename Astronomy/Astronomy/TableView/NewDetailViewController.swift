//
//  NewDetailViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/10.
//

import UIKit

class NewDetailViewController: UIViewController {
    
    @IBOutlet weak var bigImage: UIImageView!
    var picture: PictureMO!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = inputFormatter.date(from: self.picture.date!)
        inputFormatter.dateFormat = "yyyy MMM.dd"
        let result = inputFormatter.string(from: newDate!)
        
        self.title = result
        
        if let picimage = picture.image {
            self.bigImage.image = UIImage(data: picimage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMoreDetail" {
            let destination = segue.destination as! MoreDetailViewController
            destination.picture = self.picture
        }
    }
}
