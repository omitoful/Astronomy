//
//  ViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/7.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bgPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgPic.layer.opacity = 0.8
    }
}

