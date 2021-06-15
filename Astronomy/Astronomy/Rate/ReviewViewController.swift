//
//  ReviewViewController.swift
//  Astronomy
//
//  Created by 陳冠甫 on 2021/6/12.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet var rateBtn: [UIButton]!
    
    var picture: PictureMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let picimage = picture.image {
            self.bgImage.image = UIImage(data: picimage)
            self.bgImage.alpha = 0.7
        }

//        DispatchQueue.global().async {
//            if let picurl = self.picture.url, picurl != "" {
//                let url = URL(string: picurl)
//                let data = try? Data(contentsOf: url!)
//                DispatchQueue.main.async {
//                    self.bgImage.image = UIImage(data: data!)
//                    self.bgImage.alpha = 0.7
//                }
//            } else {
//                if let picimage = self.picture.image {
//                    DispatchQueue.main.async {
//                        self.bgImage.image = UIImage(data: picimage)
//                        self.bgImage.alpha = 0.7
//                    }
//                }
//            }
//        }
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        self.bgImage.addSubview(blurView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5, y: 5)
        let combineTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        // Btn
        for btn in self.rateBtn {
            btn.transform = combineTransform
            btn.alpha = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            self.rateBtn[0].alpha = 1
            self.rateBtn[0].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6, animations: {
            self.rateBtn[1].alpha = 1
            self.rateBtn[1].transform = .identity
        })
        
        UIView.animate(withDuration: 0.8, animations: {
            self.rateBtn[2].alpha = 1
            self.rateBtn[2].transform = .identity
        })
    }
}
