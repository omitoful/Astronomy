//
//  WalkthroughContentViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/15.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subheadlineLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var index = 0
    var heading = ""
    var subheading = ""
    var imagefile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headlineLabel.numberOfLines = 0
        subheadlineLabel.numberOfLines = 0
        
        headlineLabel.text = heading
        subheadlineLabel.text = subheading
        contentImageView.image = UIImage(named: imagefile)
    }

}
