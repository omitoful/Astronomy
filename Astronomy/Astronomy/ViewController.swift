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
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewed") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            
            walkthroughViewController.modalPresentationStyle = .fullScreen
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
}

